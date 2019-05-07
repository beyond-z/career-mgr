# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load",  ->
  $.tablesorter.addParser
    id: 'semester'
    is: (s) -> false
    format: (s) ->
      semesters = ['Q3', 'Q4', 'Fall', 'Q1', 'Q2', 'Spring']
      words = $.trim(s).split(/\s+/)
      
      parseInt(words[1]) * 100 + semesters.indexOf(words[0])
    type: 'numeric'

  $.tablesorter.addParser
    id: 'labelled'
    is: (s) -> false
    format: (s) -> parseFloat(s)
    type: 'numeric'

  $.tablesorter.addParser
    id: 'employment status'
    is: (s) -> false
    format: (s) -> 
      statuses = ['Unemployed', 'Not Quality', 'Part Quality', 'Service', 'Quality (Grad School)', 'Quality', 'Unknown']
      statuses.indexOf(s)
    type: 'numeric'
  
  $('#candidate-list').tablesorter({
    headers: {
      0: {sorter: false},
      2: {sorter: 'semester'}
      5: {sorter: false},
      6: {sorter: false},
      7: {sorter: false},
      8: {sorter: 'labelled'},
      9: {sorter: 'employment status'},
      10: {sorter: false}
    }
  })
  
  $('#advanced-search-toggle a').click (event) ->
    event.preventDefault()
    
    if /show/.test($(this).text())
      show_advanced_search()
    else
      hide_advanced_search()

  $('input[type=checkbox]#check-all-candidates').click (event) ->
    if $(this).is(':checked')
      $('.candidate-checkbox').prop('checked', true)
    else
      $('.candidate-checkbox').prop('checked', false)
      
  hide_advanced_search = () ->
    $('#advanced-search-toggle a').text('+ show advanced search')
    $('#advanced-search').hide();

  show_advanced_search = () ->
    $('#advanced-search-toggle a').text('- hide advanced search')
    $('#advanced-search').show();
      
  has_input = (name) ->
    !!($('input[name="' + name + '"]').val().length > 0)
    
  has_unchecked_boxes = (name) ->
    !!($('input[name="' + name + '"]:not(:checked)').length > 0)
    
  set_advanced_search_visibility = () ->
    if $('#advanced-search-toggle').length > 0
      text_field_names = ['search[gpa][from]', 'search[gpa][from]', 'search[graduation_year][from]', 'search[graduation_year][from]']
      
      # if any advanced fields have been altered, show advanced options
      if has_unchecked_boxes('search[employment_statuses][]') or text_field_names.some(has_input)
        show_advanced_search()
    
  set_advanced_search_visibility()