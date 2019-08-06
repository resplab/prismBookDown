$(document).ready(function(){
  $('.dropdown-menu a.dropdown-item').on("click", function(e){
            var optionValue = $(this).attr("value");
            $(this).parent().siblings().dropdown("toggle");
            if(optionValue){
                $(".code").not("." + optionValue).hide();
                $("." + optionValue).show();
            } else{
                $(".code").hide();
            }
        });
    e.preventDefault();
});


// COPY TO CLIPBOARD
// Attempts to use .execCommand('copy') on a created text field
// Falls back to a selectable alert if not supported
// Attempts to display status in Bootstrap tooltip
// ------------------------------------------------------------------------------

function copyToClipboard(text, el) {
  var copyTest = document.queryCommandSupported('copy');
  var elOriginalText = el.attr('data-original-title');

  if (copyTest === true) {
    var copyTextArea = document.createElement("textarea");
    copyTextArea.value = text;
    document.body.appendChild(copyTextArea);
    copyTextArea.select();
    try {
      var successful = document.execCommand('copy');
      var msg = successful ? 'Copied!' : 'Whoops, not copied!';
      el.attr('data-original-title', msg).tooltip('show');
    } catch (err) {
      console.log('Oops, unable to copy');
    }
    document.body.removeChild(copyTextArea);
    el.attr('data-original-title', elOriginalText);
  } else {
    // Fallback if browser doesn't support .execCommand('copy')
    window.prompt("Copy to clipboard: Ctrl+C or Command+C, Enter", text);
  }
}

$(document).ready(function() {
  // Initialize
  // ---------------------------------------------------------------------

  // Tooltips
  // Requires Bootstrap 3 for functionality
  $('.js-tooltip').tooltip();

  // Copy to clipboard
  // Grab any text in the attribute 'data-copy' and pass it to the
  // copy function
  $('.js-copy').click(function() {
    var text = $(this).parent().parent().parent().parent().siblings().find('.code').not("code[style='display: none;']").text();
    var el = $(this);
    copyToClipboard(text, el);
  });
});
