use chrono::{DateTime, Local};
use flutter_rust_bridge::frb;
use uuid::Uuid;

#[derive(Debug, PartialEq, Clone)]
#[frb(opaque)]
//#[frb(non_opaque)]
pub enum Priority {
    Low,
    Medium,
    High,
}

impl Priority {
    #[flutter_rust_bridge::frb(sync)]
    pub fn Low() -> Priority {
        Priority::Low
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn Medium() -> Priority {
        Priority::Medium
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn High() -> Priority {
        Priority::High
    }
}

#[derive(Debug, Clone)]
#[frb(opaque)]
//#[frb(non_opaque)]
pub struct Task {
    id: Uuid,
    title: String,
    subtitle: String,
    created_at: DateTime<Local>,
    is_completed: bool,
    priority: Priority,
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

    // // Set the task priority
    // pub fn set_id(&mut self, id: Uuid) {
    //     self.id = id;
    // }

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

    // Mark a task as incomplete
    // #[flutter_rust_bridge::frb(sync)]
    // pub fn mark_incomplete(&mut self) {
    //     self.is_completed = false;
    // }

    #[flutter_rust_bridge::frb(sync)]
    pub fn is_completed(&mut self) -> bool {
        self.is_completed.clone();
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
#[flutter_rust_bridge::frb(sync)]
pub fn filter_tasks_by_completion(tasks: Vec<Task>, is_completed: bool) -> Vec<Task> {
    tasks
        .into_iter()
        .filter(|task| task.is_completed == is_completed)
        .collect()
}

// Function to filter tasks by priority
#[flutter_rust_bridge::frb(sync)]
pub fn filter_tasks_by_priority(tasks: Vec<Task>, priority: Priority) -> Vec<Task> {
    tasks
        .into_iter()
        .filter(|task| task.priority == priority)
        .collect()
}
