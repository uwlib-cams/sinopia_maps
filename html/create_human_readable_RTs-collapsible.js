
/* toggle carets when clicked */
var toggler = document.getElementsByClassName("caret");
var i;
for (i = 0; i < toggler.length; i++) {
  toggler[i].addEventListener("click", function() {
    this.parentElement.querySelector(".nested").classList.toggle("active");
    this.classList.toggle("caret-down");
  });
}

/* toggle guidance caret when jump link is clicked (from prop list to prop detail) */
window.addEventListener("hashchange", function(){
  var hash = (window.location.hash).substring(1)
  var el = document.getElementById(hash)
  var tog = el.getElementsByClassName("caret")
  for (i = 0; i < tog.length; i++) {
    if (!tog[i].parentElement.querySelector(".nested").classList.contains("active")) {
      tog[i].parentElement.querySelector(".nested").classList.toggle("active");
      tog[i].classList.toggle("caret-down");
    }
  }
  jump(hash)
})

/* toggle guidance caret when external link directs to prop detail */
window.addEventListener("DOMContentLoaded", function(){
  var hash = (window.location.hash).substring(1)
  var el = document.getElementById(hash)
  var tog = el.getElementsByClassName("caret")
  for (i = 0; i < tog.length; i++) {
    if (!tog[i].parentElement.querySelector(".nested").classList.contains("active")) {
      tog[i].parentElement.querySelector(".nested").classList.toggle("active");
      tog[i].classList.toggle("caret-down");
    }
  }
  jump(hash)
})

/* ensures links jump to top of prop detail */
function jump(h){
  var url = location.href;
  location.href = "#"+h;              
}