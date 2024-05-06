use uuid::Uuid;

pub struct Task {
    pub id: Uuid,
      pub title: String,
      pub subtitle: String,
      pub createdAt: DateTime<Local>,
      pub isCompleted: bool,
}