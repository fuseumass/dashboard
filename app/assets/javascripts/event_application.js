$(document).on('turbolinks:load', function () {
    if (!(page.controller() === 'event_applications' && page.action() === 'new' || page.action() === 'edit')) {
        return;
    }
    unhideField(document.getElementById('javascript-container'));
    charCounter();
    toggleHiddenField('event_application_food_restrictions_info', 'event_application_food_restrictions_true');
    updateAge();
});


$(document).on('ready', function () {
    if (!(page.controller() === 'event_applications' && page.action() === 'create' || page.action() === 'update')) {
        return;
    }
    unhideField(document.getElementById('javascript-container'));
    charCounter();
    toggleHiddenField('event_application_food_restrictions_info', 'event_application_food_restrictions_true');
    updateAge();
});


/*
This function runs everytime a page completely reloads (this means turbolinks 
are excluded). The purpose of this function is to make all the hidden field 
persist through refresh and reloads.
*/

/*
The autoFormatPhoneNum function takes in no agruments

The function's purpose is to format the applicant's phone number to something 
like this: '(XXX) XXX-XXXX'.

This function returns the formatted number back to the textfield.
*/
function autoFormatPhoneNum() {
    var phoneTextField = document.getElementById('event_application_phone');
    var phoneValue = phoneTextField.value;
    var cursorPositionStart = phoneTextField.selectionStart;
    var cursorPositionEnd = phoneTextField.selectionEnd;
    if (phoneValue.length >= 10 && event.keyCode == 8) {
        switch (cursorPositionEnd) {
            case 1:
                cursorPositionStart = 0;
                cursorPositionEnd = 0;
                break;
            case 2:
                cursorPositionStart = 1;
                cursorPositionEnd = 1;
                break;
            case 3:
                cursorPositionStart = 2;
                cursorPositionEnd = 2;
                break;
            case 6:
                cursorPositionStart = 3;
                cursorPositionEnd = 3;
                break;
            case 7:
                cursorPositionStart = 4;
                cursorPositionEnd = 4;
                break;
            case 8:
                cursorPositionStart = 5;
                cursorPositionEnd = 5;
                break;
            case 10:
                cursorPositionStart = 6;
                cursorPositionEnd = 6;
                break;
            case 11:
                cursorPositionStart = 7;
                cursorPositionEnd = 7;
                break;
            case 12:
                cursorPositionStart = 8;
                cursorPositionEnd = 8;
                break;
            case 13:
            case 14:
                cursorPositionStart = 9;
                cursorPositionEnd = 9;
                break;
            default:
        }
    }
    phoneValue = phoneValue.split(new RegExp('[-()\\s]', 'g')).join('');
    if (event.keyCode != 37 && event.keyCode != 39) {
        if (phoneValue.length == 10) {
            var areaCode = phoneValue.substring(0, 3);
            areaCode = '('.concat(areaCode).concat(') ');
            var phoneNum = '';
            if (phoneValue.length >= 3) {
                phoneNum = phoneValue.substring(3);
                if (phoneNum.length >= 3) {
                    phoneNum = phoneNum.match(new RegExp('.{1,4}$|.{1,3}', 'g')).join('-');
                }
            }
            phoneValue = areaCode + phoneNum;
            $(phoneTextField).val(phoneValue);
            if (cursorPositionEnd != 14 && !event.ctrlKey) {
                cursorPositionStart = 14;
                cursorPositionEnd = 14;
            }
        } else {
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
function charCounter(endIndex) {

    var textBox = document.getElementsByClassName('text-box');
    var textCounter = document.getElementsByClassName('text-box-counter');

    if (typeof endIndex === 'undefined') {
        endIndex = textBox.length;
    }

    for (var x = 0; x < endIndex; x++) {
        var currLength = textBox[x].value.length;
        var maxLength = textCounter[x].innerHTML.substring(textCounter[x].innerHTML.indexOf('of') + 3);
        var oldText = textCounter[x].innerHTML.substring(textCounter[x].innerHTML.indexOf('of'));
        if (parseInt(currLength) > parseInt(maxLength)) {
            textCounter[x].style.color = 'red';
            textCounter[x].style.fontWeight = 'bold';
        } else {
            textCounter[x].style.color = 'inherit';
            textCounter[x].style.fontWeight = 'inherit';
        }
        textCounter[x].innerHTML = currLength + ' ' + oldText;
    }
}

/*
The unhideField function takes in only one agrument an id attribute.

The function takes the id attribute, finds the element, and changes the
element's CSS display style to 'block', making the element visible to
the viewer.

This function does not return anything.
*/
function unhideField(field) {
    if (field) {
        field.style.display = 'block';
    }
}

/*
The unhideField function takes in only one agrument an id attribute.

The function takes the id attribute, finds the element, and changes the
element's CSS display style to 'none', making the element invisible to
the viewer.

This function does not return anything.
*/
function hideField(field) {
    if (field) {
        field.style.display = 'none';
    }
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
function toggleHiddenField(hiddenId, checkBoxId) {
    var field = document.getElementById(hiddenId).parentNode
    var checkBox = document.getElementById(checkBoxId);
    if (checkBox) {
        checkBox.checked ? unhideField(field) : hideField(field);
    } else {
        hideField(field);
    }
}

function updateResumeFileLabel() {
    var fileLabel = document.getElementsByClassName('custom-file-label')[0];
    var resumeFileField = document.getElementById('event_application_resume');
    if(resumeFileField) {
        var pathArray = resumeFileField.value.split('\\');
        var fileName = pathArray[pathArray.length-1];
        fileLabel.innerHTML = fileName;
    }
}

function updateAge() {
    var age = document.getElementById('event_application_age').value;
    age = parseInt(age);

    var resumeLabel = document.querySelector('label[for=event_application_resume]');
    resumeLabel.classList.remove('event-application-required-field');
    resumeLabel.classList.add('resume-optional');
    
    // Made resumes optional;
    // if (age) {
    //     if (age <= window.MIN_RESUME_AGE) {
    //         resumeLabel.classList.remove('event-application-required-field');
    //         resumeLabel.classList.add('resume-optional');
    //     } else {
    //         resumeLabel.classList.add('event-application-required-field');
    //         resumeLabel.classList.remove('resume-optional');
    //     }
    // } else {
    //     resumeLabel.classList.add('event-application-required-field');
    //     resumeLabel.classList.remove('resume-optional');
    // }
}