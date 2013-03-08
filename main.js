$(document).ready(function () {
  $("#eval").click(function () {
    try {
      var result = calculator.parse($("#input").val())
      $("#output").html(JSON.stringify(result, undefined, 0));
    } catch (e) {
      $("#output").html(String(e));
    }
  });
});
