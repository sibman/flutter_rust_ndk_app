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
) -> Result<Task, rusqlite::Error> {
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

#[cfg(test)]
mod tests {
    use super::*;
    use serial_test::serial;

    #[test]
    #[serial]
    fn test_create_task() {
        let task = create_task(
            "Test Task".to_string(),
            "Test Subtitle".to_string(),
            Priority::Low,
        )
        .unwrap();
        assert_eq!(task.title, "Test Task".to_string());
        assert_eq!(task.subtitle, "Test Subtitle".to_string());
        assert_eq!(task.priority, Priority::Low);
        assert_eq!(task.is_completed, false);
    }

    #[test]
    #[serial]
    fn test_get_all_tasks() {
        for i in 1..=5 {
            let _task = create_task(
                format!("Test Task{}", i),
                "Test Subtitle".to_string(),
                Priority::Low,
            )
            .unwrap();
        }
        let tasks = read_all_tasks(Local::now(), false, true);
        assert!(tasks.is_ok());
        assert_eq!(tasks.unwrap().len(), 5);
    }

    #[test]
    #[serial]
    fn test_update_task() {
        let task = create_task(
            "Test Task".to_string(),
            "Test Subtitle".to_string(),
            Priority::Low,
        )
        .unwrap();

        let task_id = task.id;
        let new_title = "Updated Task".to_string();
        let new_subtitle = "Updated Subtitle".to_string();
        let new_priority = Priority::Normal;
        let new_completed = true;
        assert_eq!(
            update_task(
                &task_id,
                new_title.clone(),
                new_subtitle.clone(),
                new_priority.clone(),
                new_completed.clone()
            ),
            Ok(())
        );
        // Add assertions to check the updated task
        let result = read_task(&task_id);
        assert!(result.is_ok());
        if let Ok(Some(task)) = result {
            assert_eq!(task.title, new_title);
            assert_eq!(task.subtitle, new_subtitle);
            assert_eq!(task.priority, new_priority);
            assert_eq!(task.is_completed, new_completed);
        } else {
            panic!("Cannot find the task with id {}", task_id);
        }
    }

    #[test]
    #[serial]
    fn test_delete_task() {
        let task = create_task(
            "Test Task".to_string(),
            "Test Subtitle".to_string(),
            Priority::Low,
        )
        .unwrap();

        let task_id = task.id;
        assert_eq!(delete_task(&task_id), Ok(()));
    }

    // #[test]
    // fn test_tasks_by_completion() {
    //     let tasks = vec![
    //         Task {
    //             id: Uuid::new_v4(),
    //             title: "Task 1".to_string(),
    //             subtitle: "Subtitle 1".to_string(),
    //             priority: Priority::Low,
    //             is_completed: true,
    //             created_at: Local::now(),
    //         },
    //         Task {
    //             id: Uuid::new_v4(),
    //             title: "Task 2".to_string(),
    //             subtitle: "Subtitle 2".to_string(),
    //             priority: Priority::Medium,
    //             is_completed: false,
    //             created_at: Local::now(),
    //         },
    //         Task {
    //             id: Uuid::new_v4(),
    //             title: "Task 3".to_string(),
    //             subtitle: "Subtitle 3".to_string(),
    //             priority: Priority::High,
    //             is_completed: true,
    //             created_at: Local::now(),
    //         },
    //     ];

    //     let completed_tasks = tasks_by_completion(true);
    //     assert_eq!(completed_tasks.len(), 2);
    //     assert!(completed_tasks.iter().all(|task| task.is_completed));

    //     let incomplete_tasks = tasks_by_completion(false);
    //     assert_eq!(incomplete_tasks.len(), 1);
    //     assert!(incomplete_tasks.iter().all(|task| !task.is_completed));
    // }

    // #[test]
    // fn test_tasks_by_priority() {
    //     let tasks = vec![
    //         Task {
    //             id: Uuid::new_v4(),
    //             title: "Task 1".to_string(),
    //             subtitle: "Subtitle 1".to_string(),
    //             priority: Priority::Low,
    //             is_completed: false,
    //             created_at: Local::now(),
    //         },
    //         Task {
    //             id: Uuid::new_v4(),
    //             title: "Task 2".to_string(),
    //             subtitle: "Subtitle 2".to_string(),
    //             priority: Priority::Medium,
    //             is_completed: false,
    //             created_at: Local::now(),
    //         },
    //         Task {
    //             id: Uuid::new_v4(),
    //             title: "Task 3".to_string(),
    //             subtitle: "Subtitle 3".to_string(),
    //             priority: Priority::High,
    //             is_completed: false,
    //             created_at: Local::now(),
    //         },
    //     ];

    //     let low_priority_tasks = tasks_by_priority(Priority::Low);
    //     assert_eq!(low_priority_tasks.len(), 1);
    //     assert!(low_priority_tasks
    //         .iter()
    //         .all(|task| task.priority == Priority::Low));

    //     let medium_priority_tasks = tasks_by_priority(Priority::Medium);
    //     assert_eq!(medium_priority_tasks.len(), 1);
    //     assert!(medium_priority_tasks
    //         .iter()
    //         .all(|task| task.priority == Priority::Medium));

    //     let high_priority_tasks = tasks_by_priority(Priority::High);
    //     assert_eq!(high_priority_tasks.len(), 1);
    //     assert!(high_priority_tasks
    //         .iter()
    //         .all(|task| task.priority == Priority::High));
    // }

    #[test]
    #[serial]
    fn test_read_task() {
        let task = create_task(
            "Test Task".to_string(),
            "Test Subtitle".to_string(),
            Priority::Low,
        )
        .unwrap();

        let task_id = task.id;
        let result = read_task(&task_id);
        if let Ok(Some(r_task)) = result {
            assert_eq!(r_task, task);
        } else {
            panic!("Cannot find the task with id {}", task_id);
        }
    }

    #[test]
    #[serial]
    fn test_delete_tasks() {
        let _task = create_task(
            "Test Task".to_string(),
            "Test Subtitle".to_string(),
            Priority::Low,
        )
        .unwrap();

        let result = delete_tasks();
        assert_eq!(result, Ok(()));

        let tasks = read_all_tasks(Local::now(), false, true);
        assert!(tasks.is_ok());
        assert_eq!(tasks.unwrap().len(), 0);
    }
}
