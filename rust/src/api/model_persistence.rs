use crate::api::model::Priority;
use crate::api::model::Task;
use chrono::{DateTime, Local};
use lazy_static::lazy_static;
use rusqlite::{params, Connection, Error as RusqliteError};
use std::sync::Mutex;
use uuid::Uuid;

lazy_static! {
    static ref CONNECTION: CachedConnection = {
        let conn = CachedConnection::new("test.db").expect("Failed to create connection");
        conn
    };
}

#[derive(Debug)]
struct CachedConnection {
    conn: Mutex<Option<Connection>>,
}

impl CachedConnection {
    fn new(db_path: &str) -> Result<Self, RusqliteError> {
        let db_path = db_path.to_owned(); // Clone the String
        let conn = Connection::open(&db_path)?;
        conn.execute(
            "CREATE TABLE IF NOT EXISTS tasks (
                    id TEXT PRIMARY KEY,
                    title TEXT NOT NULL,
                    subtitle TEXT,
                    created_at TEXT NOT NULL,
                    is_completed INTEGER NOT NULL,
                    priority TEXT NOT NULL)",
            [],
        )?;
        Ok(Self {
            conn: Mutex::new(Some(conn)),
        }) //db_path,
    }

    //fn get_connection(&mut self) -> Result<&mut Connection, RusqliteError> { //TODO: need to figure out the issue returning connection through function
    //     let conn = self.conn.get_mut().unwrap();

    //     if conn.is_none() {
    //         let new_conn = Connection::open(&self.db_path)?;
    //         new_conn.execute(
    //             "CREATE TABLE IF NOT EXISTS tasks (
    //                 id TEXT PRIMARY KEY,
    //                 title TEXT NOT NULL,
    //                 subtitle TEXT,
    //                 created_at TEXT NOT NULL,
    //                 is_completed INTEGER NOT NULL,
    //                 priority TEXT NOT NULL
    //             )",
    //             [],
    //         )?;
    //         *conn = Some(new_conn);
    //     }

    //     conn.as_mut()
    //         .ok_or(RusqliteError::InvalidPath(PathBuf::from(&self.db_path)))
    //}
}

#[derive(Debug)]
enum CustomError {
    ParsingError(String),
    InvalidConnection(String),
}

impl From<CustomError> for RusqliteError {
    fn from(err: CustomError) -> Self {
        match err {
            CustomError::ParsingError(msg) => {
                Self::InvalidColumnType(0, msg, rusqlite::types::Type::Text)
            }
            CustomError::InvalidConnection(msg) => {
                Self::InvalidColumnType(0, msg, rusqlite::types::Type::Text)
            }
        }
    }
}

// Database interaction functions
// CRUD operations
// Create a new task in the database
pub fn create_task_in_db(
    title: &str,
    subtitle: &str,
    priority: Priority,
) -> Result<(), RusqliteError> {
    let mut conn_lock = CONNECTION.conn.lock().unwrap();
    let conn = conn_lock
        .as_mut()
        .ok_or(RusqliteError::from(CustomError::InvalidConnection(
            "Invalid connection".to_string(),
        )))?;
    let task = Task::new(title, subtitle, priority);
    create_task(conn, &task)?;
    Ok(())
}
// Read all tasks from the database
pub fn read_all_tasks_from_db() -> Result<Vec<Task>, RusqliteError> {
    let mut conn_lock = CONNECTION.conn.lock().unwrap();
    let conn = conn_lock
        .as_mut()
        .ok_or(RusqliteError::from(CustomError::InvalidConnection(
            "Invalid connection".to_string(),
        )))?;
    read_tasks(conn)
}
// Read task from the database
pub fn read_task_from_db(task_id: &Uuid) -> Result<Option<Task>, RusqliteError> {
    let mut conn_lock = CONNECTION.conn.lock().unwrap();
    let conn = conn_lock
        .as_mut()
        .ok_or(RusqliteError::from(CustomError::InvalidConnection(
            "Invalid connection".to_string(),
        )))?;
    //let mut conn = CONNECTION.get_connection()?; //TODO: figure out why does not work
    read_task(conn, task_id)
}
// Update a task in the database
pub fn update_task_in_db(
    task_id: &Uuid,
    title: &str,
    subtitle: &str,
    priority: Priority,
    is_completed: bool,
) -> Result<(), RusqliteError> {
    let mut conn_lock = CONNECTION.conn.lock().unwrap();
    let conn = conn_lock
        .as_mut()
        .ok_or(RusqliteError::from(CustomError::InvalidConnection(
            "Invalid connection".to_string(),
        )))?;
    let task = Task {
        id: task_id.clone(),
        title: title.to_string(),
        subtitle: subtitle.to_string(),
        created_at: Local::now(),
        is_completed: is_completed,
        priority,
    };
    update_task(conn, &task)?;
    Ok(())
}
// Delete a task from the database
pub fn delete_task_from_db(task_id: &Uuid) -> Result<(), RusqliteError> {
    let mut conn_lock = CONNECTION.conn.lock().unwrap();
    let conn = conn_lock
        .as_mut()
        .ok_or(RusqliteError::from(CustomError::InvalidConnection(
            "Invalid connection".to_string(),
        )))?;
    delete_task(conn, task_id)
}

fn create_task(conn: &Connection, task: &Task) -> Result<(), RusqliteError> {
    conn.execute(
        "INSERT INTO tasks (
        id,
        title,
        subtitle,
        created_at,
        is_completed,
        priority) VALUES (
          ?, ?, ?, ?, ?, ?)",
        params![
            task.id.to_string(),
            task.title,
            task.subtitle,
            task.created_at.to_rfc3339(), // 1996-12-19T16:39:57-08:00 ISO 8601
            task.is_completed as i32,
            format!("{:?}", task.priority)
        ],
    )?;
    Ok(())
}

fn read_tasks(conn: &Connection) -> Result<Vec<Task>, RusqliteError> {
    let mut stmt =
        conn.prepare("SELECT id, title, subtitle, created_at, is_completed, priority FROM tasks")?;
    let task_iter = stmt.query_map([], |row| {
        let row_id = row.get::<_, String>(0)?; // Extract the string
        let parsed_id: Uuid = match Uuid::parse_str(&row_id) {
            Ok(id) => id,
            Err(err) => {
                // Handle the uuid::Error appropriately (e.g., return Err)
                return Err(RusqliteError::from(CustomError::ParsingError(format!(
                    "Error parsing UUID: {}",
                    err
                ))));
            }
        };
        let title: String = row.get(1)?;
        let subtitle: String = row.get(2)?;
        let created_at_str = row.get::<_, String>(3)?;
        let created_at = match DateTime::parse_from_rfc3339(&created_at_str) {
            Ok(dt) => dt.with_timezone(&Local),
            Err(err) => {
                // Handle the chrono::ParseError appropriately (e.g., return Err)
                return Err(RusqliteError::from(CustomError::ParsingError(format!(
                    "Error parsing data: {}",
                    err
                ))));
            }
        };
        let is_completed: bool = row.get(4)?;
        let priority_str: String = row.get(5)?;
        let priority = match priority_str.as_str() {
            "Low" => Priority::Low,
            "Medium" => Priority::Medium,
            "High" => Priority::High,
            _ => panic!("Invalid priority value in database"),
        };
        Ok(Task {
            id: parsed_id,
            title,
            subtitle,
            created_at: created_at,
            is_completed: is_completed,
            priority,
        })
    })?;
    let mut tasks: Vec<Task> = Vec::new();
    for task_result in task_iter {
        tasks.push(task_result?);
    }
    Ok(tasks)
}

fn read_task(conn: &Connection, task_id: &Uuid) -> Result<Option<Task>, RusqliteError> {
    let mut stmt = conn.prepare(
        "SELECT id, title, subtitle, created_at, is_completed, priority FROM tasks WHERE id = ?",
    )?;
    let mut task_iter = stmt.query([task_id.to_string()])?;
    let mut task: Option<Task> = None;
    while let Some(row) = task_iter.next()? {
        let row = row;
        let row_id = row.get::<_, String>(0)?; // Extract the string
        let parsed_id: Uuid = match Uuid::parse_str(&row_id) {
            Ok(id) => id,
            Err(err) => {
                // Handle the uuid::Error appropriately (e.g., return Err)
                return Err(RusqliteError::from(CustomError::ParsingError(format!(
                    "Error parsing UUID: {}",
                    err
                ))));
            }
        };
        let title: String = row.get(1)?;
        let subtitle: String = row.get(2)?;
        //let created_at: DateTime<Local> = DateTime::parse_from_rfc3339(&row.get(3)?)?.into();
        let created_at_str = row.get::<_, String>(3)?;
        let created_at = match DateTime::parse_from_rfc3339(&created_at_str) {
            Ok(dt) => dt.with_timezone(&Local),
            Err(err) => {
                // Handle the chrono::ParseError appropriately (e.g., return Err)
                return Err(RusqliteError::from(CustomError::ParsingError(format!(
                    "Error parsing data: {}",
                    err
                ))));
            }
        };
        let is_completed: bool = row.get(4)?;
        let priority_str: String = row.get(5)?;
        let priority = match priority_str.as_str() {
            "Low" => Priority::Low,
            "Medium" => Priority::Medium,
            "High" => Priority::High,
            _ => panic!("Invalid priority value in database"),
        };
        task = Some(Task {
            id: parsed_id,
            title,
            subtitle,
            created_at: created_at,
            is_completed: is_completed,
            priority,
        });
    }
    Ok(task)
}

fn update_task(conn: &Connection, task: &Task) -> Result<(), RusqliteError> {
    conn.execute(
        "UPDATE tasks SET
          title = ?,
          subtitle = ?,
          created_at = ?,
          is_completed = ?,
          priority = ?
        WHERE id = ?",
        params![
            task.title,
            task.subtitle,
            task.created_at.to_rfc3339(),
            task.is_completed as i32,
            format!("{:?}", task.priority),
            task.id.to_string()
        ],
    )?;
    Ok(())
}

fn delete_task(conn: &Connection, task_id: &Uuid) -> Result<(), RusqliteError> {
    conn.execute("DELETE FROM tasks WHERE id = ?", [task_id.to_string()])?;
    Ok(())
}
