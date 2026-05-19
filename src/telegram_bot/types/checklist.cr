module TelegramBot
  class ChecklistTask
    include JSON::Serializable

    property id : Int32
    property text : String
    property text_entities : Array(MessageEntity)?
    property completed_by_user : User?
    property completed_by_chat : Chat?
    property completion_date : Int32?
  end

  class Checklist
    include JSON::Serializable

    property title : String
    property title_entities : Array(MessageEntity)?
    property tasks : Array(ChecklistTask)
    property? others_can_add_tasks : Bool?
    property? others_can_mark_tasks_as_done : Bool?
  end

  class InputChecklistTask
    include JSON::Serializable

    property id : Int32
    property text : String
    property parse_mode : String?
    property text_entities : Array(MessageEntity)?

    def initialize(
      @id : Int32,
      @text : String,
      *,
      @parse_mode = nil,
      @text_entities = nil,
    )
    end
  end

  class InputChecklist
    include JSON::Serializable

    property title : String
    property parse_mode : String?
    property title_entities : Array(MessageEntity)?
    property tasks : Array(InputChecklistTask)
    property? others_can_add_tasks : Bool?
    property? others_can_mark_tasks_as_done : Bool?

    def initialize(
      @title : String,
      @tasks : Array(InputChecklistTask),
      *,
      @parse_mode = nil,
      @title_entities = nil,
      @others_can_add_tasks = nil,
      @others_can_mark_tasks_as_done = nil,
    )
    end
  end

  class ChecklistTasksDone
    include JSON::Serializable

    property checklist_message : Message?
    property marked_as_done_task_ids : Array(Int32)?
    property marked_as_not_done_task_ids : Array(Int32)?
  end

  class ChecklistTasksAdded
    include JSON::Serializable

    property checklist_message : Message?
    property tasks : Array(ChecklistTask)
  end
end
