// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

function changeSliderOutput(output_id, desc_id, slider_id, scores){
    output_id.value = slider_id.value
    desc_id.value = scores.find(o => o['points'] >= slider_id.value)['description']
}