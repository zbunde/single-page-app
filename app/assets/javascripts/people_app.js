// DISCLAIMER:
//
// This is just one implementation of many, many possible implementations.
// This was written specifically to highlight some specific techniques, such as:
//
//  * generating json strings from forms
//  * iterating through data in templates (errors.jst.ejs) as well as in javascript (renderInitialPage)
//  * storing the JSON data along with DOM elements
//
// We don't necessarily endorse any of these techniques as best-practices for building apps, but we do think they
// are concepts that can be helpful to understand.
//
window.PeopleApp = {

  initialize: function (path) {
    $.getJSON(path, this.renderInitialPage);
  },

  // This function is called with data from GET /people
  // It is responsible for:
  //
  //  * appending the new-person-form to the page
  //  * iterating through each person appending the person-show dom to the page
  //
  renderInitialPage: function (response) {
    $.each(response._embedded.people, function () {
      var $html = $(JST['templates/person_show'](this));
      $html.data('person', this);
      $("[data-container=people]").append($html);
    });
  }

};