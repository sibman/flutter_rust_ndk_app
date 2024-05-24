//use crate::api::model;
//use crate::api::model::filter_tasks_by_completion;
//use crate::api::model::filter_tasks_by_priority;
use crate::api::model::{Priority, Task};
//use crate::api::model_persistence;
//use crate::api::model_persistence::create_task_in_db;
//use crate::api::model_persistence::delete_task_from_db;
//use crate::api::model_persistence::read_all_tasks_from_db;
//use crate::api::model_persistence::read_task_from_db;
//use crate::api::model_persistence::update_task_in_db;
//use rusqlite::Error;
use chrono::DateTime;
use chrono::Local;
use std::env;
use uuid::Uuid;

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    env::set_var("RUST_BACKTRACE", "1");
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

// Function to filter tasks by completion status
#[flutter_rust_bridge::frb(sync)]
pub fn tasks_by_completion(is_completed: bool) -> Vec<Task> {
    let tasks = match read_all_tasks(Local::now(), false, true) {
        Ok(tasks) => tasks,
        Err(error) => panic!("Problem reading all tasks: {:?}", error),
    };
    crate::api::model::filter_tasks_by_completion(tasks, is_completed)
}

// Function to filter tasks by priority
#[flutter_rust_bridge::frb(sync)]
pub fn tasks_by_priority(priority: Priority) -> Vec<Task> {
    let tasks = match read_all_tasks(Local::now(), false, true) {
        Ok(tasks) => tasks,
        Err(error) => panic!("Problem reading all tasks: {:?}", error),
    };
    crate::api::model::filter_tasks_by_priority(tasks, priority)
}

#[flutter_rust_bridge::frb(sync)]
pub fn create_task(
    task_title: String,
    task_subtitle: String,
    task_priority: Priority,
) -> Result<(), rusqlite::Error> {
    crate::api::model_persistence::create_task_in_db(&task_title, &task_subtitle, task_priority)
}
// Read all tasks from the database
#[flutter_rust_bridge::frb(sync)]
pub fn read_all_tasks(
    created_at: DateTime<Local>,
    is_completed_only: bool,
    is_ignore_created_at: bool,
) -> Result<Vec<Task>, rusqlite::Error> {
    crate::api::model_persistence::read_all_tasks_from_db(
        created_at,
        is_completed_only,
        is_ignore_created_at,
    )
}
// Read task from the database
#[flutter_rust_bridge::frb(sync)]
pub fn read_task(task_id: &Uuid) -> Result<Option<Task>, rusqlite::Error> {
    crate::api::model_persistence::read_task_from_db(task_id)
}
// Update a task in the database
#[flutter_rust_bridge::frb(sync)]
pub fn update_task(
    task_id: &Uuid,
    title: String,
    subtitle: String,
    priority: Priority,
    is_completed: bool,
) -> Result<(), rusqlite::Error> {
    crate::api::model_persistence::update_task_in_db(
        task_id,
        &title,
        &subtitle,
        priority,
        is_completed,
    )
}
// Delete a task from the database
#[flutter_rust_bridge::frb(sync)]
pub fn delete_task(task_id: &Uuid) -> Result<(), rusqlite::Error> {
    crate::api::model_persistence::delete_task_from_db(task_id)
}

// Delete a task from the database
#[flutter_rust_bridge::frb(sync)]
pub fn delete_tasks() -> Result<(), rusqlite::Error> {
    crate::api::model_persistence::delete_tasks_from_db()
}
