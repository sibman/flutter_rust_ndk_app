use chrono::{DateTime, Local};
use uuid::Uuid;

#[derive(Debug, PartialEq, Clone)]
pub enum Priority {
    Low,
    Medium,
    High,
}

#[derive(Debug, Clone)]
pub struct Task {
    pub id: Uuid,
    pub title: String,
    pub subtitle: String,
    pub created_at: DateTime<Local>,
    pub is_completed: bool,
    pub priority: Priority,
}

// Implement functionality for managing tasks

impl Task {
    // Create a new task
    pub fn new(title: &str, subtitle: &str, priority: Priority) -> Self {
        Self {
            id: Uuid::new_v4(),
            title: title.to_string(),
            subtitle: subtitle.to_string(),
            created_at: Local::now(),
            is_completed: false,
            priority,
        }
    }

    // Mark a task as completed
    pub fn mark_completed(&mut self) {
        self.is_completed = true;
    }

    // Mark a task as incomplete
    pub fn mark_incomplete(&mut self) {
        self.is_completed = false;
    }

    // Set the task priority
    pub fn set_priority(&mut self, priority: Priority) {
        self.priority = priority;
    }
}

// Additional functionality (optional)

// Function to filter tasks by completion status
pub fn filter_tasks_by_completion(tasks: Vec<Task>, is_completed: bool) -> Vec<Task> {
    tasks
        .into_iter()
        .filter(|task| task.is_completed == is_completed)
        .collect()
}

// Function to filter tasks by priority
pub fn filter_tasks_by_priority(tasks: Vec<Task>, priority: Priority) -> Vec<Task> {
    tasks
        .into_iter()
        .filter(|task| task.priority == priority)
        .collect()
}
