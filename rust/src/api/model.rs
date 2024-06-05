use chrono::{DateTime, Local};
use flutter_rust_bridge::frb;
use std::fmt;
use uuid::Uuid;

#[derive(Debug, PartialEq, Clone)]
#[frb(opaque)]
//#[frb(non_opaque)]
pub enum Priority {
    Low,
    Normal,
    High,
}

impl Priority {
    #[flutter_rust_bridge::frb(sync)]
    pub fn low_priority() -> Priority {
        Priority::Low
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn normal_priority() -> Priority {
        Priority::Normal
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn high_priority() -> Priority {
        Priority::High
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn from_string(value: String) -> Priority {
        match value.as_str() {
            "Low" => Priority::Low,
            "Normal" => Priority::Normal,
            "High" => Priority::High,
            _ => panic!("Invalid priority value in database"),
        }
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn to_string(&self) -> String {
        match self {
            Priority::Low => String::from("Low"),
            Priority::Normal => String::from("Normal"),
            Priority::High => String::from("High"),
        }
    }
}

impl fmt::Display for Priority {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Priority::High => write!(f, "High"),
            Priority::Normal => write!(f, "Normal"),
            Priority::Low => write!(f, "Low"),
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
#[frb(opaque)]
//#[frb(non_opaque)]
pub struct Task {
    pub(crate) id: Uuid,
    pub(crate) title: String,
    pub(crate) subtitle: String,
    pub(crate) created_at: DateTime<Local>,
    pub(crate) is_completed: bool,
    pub(crate) priority: Priority,
}

// Implement functionality for managing tasks

impl Task {
    // Create a new task
    #[flutter_rust_bridge::frb(sync)]
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

    // Set the task priority
    #[flutter_rust_bridge::frb(sync)]
    pub fn get_id(&mut self) -> Uuid {
        self.id.clone()
    }

    // Set the task priority
    #[flutter_rust_bridge::frb(sync)]
    pub fn set_title(&mut self, title: String) {
        self.title = title;
    }

    // Set the task priority
    #[flutter_rust_bridge::frb(sync)]
    pub fn get_title(&mut self) -> String {
        self.title.clone()
    }

    // Set the task priority
    #[flutter_rust_bridge::frb(sync)]
    pub fn set_subtitle(&mut self, subtitle: String) {
        self.subtitle = subtitle;
    }

    // Set the task priority
    #[flutter_rust_bridge::frb(sync)]
    pub fn get_subtitle(&mut self) -> String {
        self.subtitle.clone()
    }

    // Set the task priority
    #[flutter_rust_bridge::frb(sync)]
    pub fn set_created_at(&mut self, created_at: DateTime<Local>) {
        self.created_at = created_at;
    }

    // Set the task priority
    #[flutter_rust_bridge::frb(sync)]
    pub fn get_created_at(&mut self) -> DateTime<Local> {
        self.created_at.clone()
    }

    // Mark a task as completed
    #[flutter_rust_bridge::frb(sync)]
    pub fn set_completed(&mut self, is_completed: bool) {
        self.is_completed = is_completed;
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn is_completed(&mut self) -> bool {
        self.is_completed.clone()
    }

    // Set the task priority
    #[flutter_rust_bridge::frb(sync)]
    pub fn set_priority(&mut self, priority: Priority) {
        self.priority = priority;
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn get_priority(&mut self) -> Priority {
        self.priority.clone()
    }
}

// Additional functionality (optional)

// Function to filter tasks by completion status
#[flutter_rust_bridge::frb(ignore)]
pub fn filter_tasks_by_completion(tasks: Vec<Task>, is_completed: bool) -> Vec<Task> {
    tasks
        .into_iter()
        .filter(|task| task.is_completed == is_completed)
        .collect()
}

// Function to filter tasks by priority
#[flutter_rust_bridge::frb(ignore)]
pub fn filter_tasks_by_priority(tasks: Vec<Task>, priority: Priority) -> Vec<Task> {
    tasks
        .into_iter()
        .filter(|task| task.priority == priority)
        .collect()
}
