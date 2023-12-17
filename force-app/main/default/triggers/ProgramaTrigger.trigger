trigger ProgramaTrigger on Programa__c(
  before insert,
  before update,
  before delete,
  after insert,
  after update,
  after delete,
  after undelete
) {
  TriggerHandler handler = new ProgramaTriggerHandler(
    Trigger.isExecuting,
    Trigger.size
  );
  switch on Trigger.operationType {
    when BEFORE_INSERT {
      handler.beforeInsert(Trigger.new);
    }
    when BEFORE_UPDATE {
      //call before update handler method
      handler.beforeUpdate(
        Trigger.new,
        Trigger.old,
        Trigger.newMap,
        Trigger.oldMap
      );
    }
    when BEFORE_DELETE {
      //call before delete handler method
      handler.beforeDelete(Trigger.old, Trigger.oldMap);
    }
    when AFTER_INSERT {
      //call after insert handler method
      handler.afterInsert(Trigger.new, Trigger.newMap);
    }
    when AFTER_UPDATE {
      //call after update handler method
      handler.afterUpdate(
        Trigger.new,
        Trigger.old,
        Trigger.newMap,
        Trigger.oldMap
      );
    }
    when AFTER_DELETE {
      //call after delete handler method
      handler.afterDelete(Trigger.old, Trigger.oldMap);
    }
    when AFTER_UNDELETE {
      //call after undelete handler method
      handler.afterUndelete(Trigger.new, Trigger.newMap);
    }
  }
}
