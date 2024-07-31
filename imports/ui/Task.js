import { Meteor } from 'meteor/meteor';
import { Template } from 'meteor/templating';

import './Task.html';

Template.task.events({
  'click .toggle-checked'() {
    Meteor.call('tasks.setIsChecked', this._id, !this.isChecked);
  },
  'click .delete'() {
    Meteor.call('tasks.remove', this._id);
  },
  'click .edit'(event, instance) {
    instance.$('.text').hide();
    instance.$('.edit-text').show().focus();
    instance.$('.edit').hide();
    instance.$('.save').show();
  },
  'click .save'(event, instance) {
    const newText = instance.$('.edit-text').val();
    if (newText) {
      Meteor.call('tasks.update', this._id, newText);
    }
    instance.$('.text').show();
    instance.$('.edit-text').hide();
    instance.$('.edit').show();
    instance.$('.save').hide();
  }
});
