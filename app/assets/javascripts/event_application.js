/*
This function runs everytime a page completely reloads (this means turbolinks 
are excluded). The purpose of this function is to make all the hidden field 
persist through refresh and reloads.
*/
$( document ).ready(function(){
  charCounter('text-box', 'char-counter')
  charCounter('text-box-2', 'char-counter-2')
  charCounter('text-box-3', 'char-counter-3');
  togglehiddenField('food-info', 'foodRadios1');
  togglehiddenField('transport-info', 'transportRadios1');
  togglehiddenField('hardware-hack-list', 'hardware-radio-1');
})

/*
The autoFormatPhoneNum function takes in no agruments

The function's purpose is to format the applicant's phone number to something 
like this: '(XXX) XXX-XXXX'.

This function returns the formatted number back to the textfield.
*/
function autoFormatPhoneNum(){
  var phoneTextField = document.getElementById('phone');
  var phoneValue = phoneTextField.value;
  var cursorPositionStart = phoneTextField.selectionStart;
  var cursorPositionEnd = phoneTextField.selectionEnd;
  if (phoneValue.length >= 10 && event.keyCode == 8){
      switch(cursorPositionEnd){
        case 1: cursorPositionStart = 0;
                cursorPositionEnd = 0;
                break;
        case 2: cursorPositionStart = 1;
                cursorPositionEnd = 1;
                break;
        case 3: cursorPositionStart = 2;
                cursorPositionEnd = 2;
                break;
        case 6: cursorPositionStart = 3;
                cursorPositionEnd = 3;
                break;
        case 7: cursorPositionStart = 4;
                cursorPositionEnd = 4;
                break;
        case 8: cursorPositionStart = 5;
                cursorPositionEnd = 5;
                break;
        case 10: cursorPositionStart = 6;
                 cursorPositionEnd = 6;
                 break;
        case 11: cursorPositionStart = 7;
                 cursorPositionEnd = 7;
                 break;
        case 12: cursorPositionStart = 8;
                 cursorPositionEnd = 8;
                 break;
        case 13:
        case 14: cursorPositionStart = 9;
                 cursorPositionEnd = 9;
          break;
        default:
      }
  }
  phoneValue = phoneValue.split(new RegExp('[-()\\s]','g')).join('');
  if(event.keyCode != 37 && event.keyCode != 39){
    if(phoneValue.length == 10){
        var areaCode = phoneValue.substring(0, 3);
        areaCode = '('.concat(areaCode).concat(') ');
        var phoneNum = '';
      if(phoneValue.length >= 3){
        phoneNum = phoneValue.substring(3);
        if(phoneNum.length >= 3){
          phoneNum = phoneNum.match(new RegExp('.{1,4}$|.{1,3}','g')).join('-');
        }
      }
      phoneValue = areaCode + phoneNum;
      $(phoneTextField).val(phoneValue);
      if(cursorPositionEnd != 14 && !event.ctrlKey){
        cursorPositionStart = 14;
        cursorPositionEnd = 14;
      }
    }else{
      $(phoneTextField).val(phoneValue);
    }
  }
  phoneTextField.setSelectionRange(cursorPositionStart, cursorPositionEnd);
}

/*
The charCounter function takes in two agruments a textBox id and a footer id

The function's purpose is to count the number of character currently in a 
textBox.

This function does not return anything.
*/
function charCounter(textAreaId, footerId){
  var textAreaField = document.getElementById(textAreaId);
  var footerField = document.getElementById(footerId);
  var counter = textAreaField.value.length;
  var index = footerField.innerHTML.indexOf('of');
  var str = footerField.innerHTML.substring(index);
  document.getElementById(footerId).innerHTML = counter + ' ' + str;
}

/*
The unhideField function takes in only one agrument an id attribute.

The function takes the id attribute, finds the element, and changes the
element's CSS display style to 'block', making the element visible to
the viewer.

This function does not return anything.
*/
function unhideField(id){
  document.getElementById(id).style.display= 'block';
}

/*
The unhideField function takes in only one agrument an id attribute.

The function takes the id attribute, finds the element, and changes the
element's CSS display style to 'none', making the element invisible to
the viewer.

This function does not return anything.
*/
function hideField(id){
  document.getElementById(id).style.display= 'none';
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
