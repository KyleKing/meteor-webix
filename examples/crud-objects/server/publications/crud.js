Meteor.publish("crud", function () {
  return Movies.find();
});