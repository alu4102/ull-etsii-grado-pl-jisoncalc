$(document).ready(function () {
  $("#compute").click(function () {
    try {
      var result = calculator.parse($("#input").val())
      $("#output").html(result);
    } catch (e) {
      $("#output").html(String(e));
    }
  });
});
