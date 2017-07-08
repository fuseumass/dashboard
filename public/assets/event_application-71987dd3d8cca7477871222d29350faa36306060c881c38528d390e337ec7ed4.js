/*
The unhideField function takes in only one agrument an id attribute.

The function takes the id attribute, finds the element, and changes the
element's CSS display style to 'inline', making the element visible to
the viewer.

This function does not return anything.
*/

function unhideField(id){
  document.getElementById(id).style.display= "inline";
}

/*
The unhideField function takes in only one agrument an id attribute.

The function takes the id attribute, finds the element, and changes the
element's CSS display style to 'none', making the element invisible to
the viewer.

This function does not return anything.
*/
function hideField(id){
  document.getElementById(id).style.display= "none";
}

/*
The togglehiddenField function takes in two agruments, a hiddenId attribute
and a checkBoxId attribute. The hiddenId should be the id attribute of the
field you want to make hidden or visible. The checkBoxId, on the other hand,
is the id attribute of the check box that is being check or unchecked.

The function will find the element associated with the checkBoxId and save it
into the variable checkBox. It will then see if checkBox is checked or not. If
checkBox is checked it will called the unhideField function and pass in the
hiddenId for the parameters. On the other hand checkBox is unchecked, it will
call hideField and pass in the hiddenId for the parameters.

This function does not return anything.
*/
function togglehiddenField(hiddenId, checkBoxId){
  checkBox = document.getElementById(checkBoxId);
  checkBox.checked ? unhideField(hiddenId) : hideField(hiddenId);
}
;
