$(function() {
  runCountdown();
});

$(document).on('turbolinks:load', function () {
  runCountdown();
});

function runCountdown() {
  if (!document.getElementById("countdown")) {
    return;
  }
  document.getElementById("countdown").setAttribute('style', 'font-size: 24px; text-align: center');
// Set the date we're counting down to
// e.g. "Oct 12, 2018 24:00:00"
var hackingBegins = new Date(document.getElementById("countdown").getAttribute("data-hacking-begins")).getTime();
var hackingEnds = new Date(document.getElementById("countdown").getAttribute("data-hacking-ends")).getTime();

var updateCountdown = function() {

  if (!hackingBegins || !hackingEnds) {
    clearInterval(x);
    document.getElementById("countdown").parentElement.parentElement.parentElement.parentElement.style.display = 'none';
  }

  // Get todays date and time
  var now = new Date().getTime();

  // Find the distance between now and the count down date
  var distance = hackingBegins - now;
  var prefix = "Hacking begins";

  if (distance < 0) {
    distance = hackingEnds - now;
    prefix = "Hacking ends";
  }

  if (distance < 0) {
    prefix = "Hacking is over!";
  }

  // Time calculations for days, hours, minutes and seconds
  var days = Math.floor(distance / (1000 * 60 * 60 * 24));
  var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
  var seconds = Math.floor((distance % (1000 * 60)) / 1000);

  if (document.getElementById("countdown") != null) {
    // Display the result in the element with id="demo"
    document.getElementById("countdown").innerHTML = "" +
      "<span style='font-size: 32px'>" +
      prefix + " in: " +
      "</span>" +
      "<span style='white-space: nowrap'>" +
      (days > 0 ? days + " day"+(days!=1?'s':'')+", " : "") +
      hours + " hour"+(hours!=1?'s':'')+", " +
      minutes + " min"+(minutes!=1?'s':'') +
      ((days == 0) ? ", "+seconds+" sec"+(seconds!=1?'s':'') : "") +
      "</span>";

    // If the count down is finished, write some text
    if (distance < 0) {
      clearInterval(x);
      document.getElementById("countdown").innerHTML = prefix;
    }
  } else {
    clearInterval(x);
  }
};

updateCountdown();

// Update the count down every 1 second
var x = setInterval(updateCountdown, 1000);
}
