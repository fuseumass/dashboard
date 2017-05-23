function unhideField(id){
  document.getElementById(id).style.display= "inline";
}

function hideField(id){
  document.getElementById(id).style.display= "none";
}

function togglehiddenField(hiddenId, checkBoxId){
  checkBox = document.getElementById(checkBoxId);
  checkBox.checked ? unhideField(hiddenId) : hideField(hiddenId);
}

function persistent(){
  alert("method has been called")
}
