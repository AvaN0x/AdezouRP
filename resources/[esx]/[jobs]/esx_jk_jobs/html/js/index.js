$(function() {
  $(document).keyup(function(e) {
      if ((e.keyCode == 27) || (e.keyCode == 8)) {
          $(".container-fluid").fadeOut();
          $.post('http://esx_jk_jobs/fechar', JSON.stringify({}));
      }
  });
  $(document).ready(function() {
      window.addEventListener('message', function(event) {
          var item = event.data;
          if (item.ativa == true) {
              $('.container-fluid').css('display', 'block');
          } else if (item.ativa == false) {
              $('.container-fluid').css('display', 'none');
          }
      });

      $(".firstjob").click(function() {
        $.post('http://esx_jk_jobs/setJob', JSON.stringify({
            job: $(this).val()
        }));
      });

      $(".secondjob").click(function() {
        $.post('http://esx_jk_jobs/setJob2', JSON.stringify({
            job2: $(this).val()
        }));
      });

  })
})



let scale = 0;
const cards = Array.from(document.getElementsByClassName("job"));
const inner = document.querySelector(".inner");

function slideAndScale() {
  cards.map((card, i) => {
      card.setAttribute("data-scale", i + scale);
      inner.style.transform = "translateX(" + scale * 8.5 + "em)";
  });
}

(function init() {
  slideAndScale();
  cards.map((card, i) => {
      card.addEventListener("click", () => {
          const id = card.getAttribute("data-scale");
          if (id !== 2) {
              scale -= id - 2;
              slideAndScale();
          }
      }, false);
  });
})();