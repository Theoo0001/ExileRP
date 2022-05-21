$(document).keyup(function(e) {
	if (e.key === "Escape") {
	  $('.container-fluid').css('display', 'none');
	  $.post('http://exile_jobs/fechar', JSON.stringify({}));
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

	$("#unemployed").click(function() {
		$.post('http://exile_jobs/unemployed', JSON.stringify({}));
		2

	});

	$("#baker").click(function() {
		$.post('http://exile_jobs/baker', JSON.stringify({}));
		2

	});

	$("#courier").click(function() {
		$.post('http://exile_jobs/courier', JSON.stringify({}));
		2

	});

	$("#fisherman").click(function() {
		$.post('http://exile_jobs/fisherman', JSON.stringify({}));
		2

	});

	$("#grower").click(function() {
		$.post('http://exile_jobs/grower', JSON.stringify({}));
		2

	});

	$("#milkman").click(function() {
		$.post('http://exile_jobs/milkman', JSON.stringify({}));
		2

	});
	
	$("#kawiarnia").click(function() {
		$.post('http://exile_jobs/kawiarnia', JSON.stringify({}));
		2

	});

})

let scale = 0;
const cards = Array.from(document.getElementsByClassName("job"));
const inner = document.querySelector(".inner");

function slideAndScale() {
cards.map((card, i) => {
	card.setAttribute("data-scale", i + scale);
	inner.style.transform = "translateX(" + scale * 12.5 + "em)";
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

