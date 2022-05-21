var zdrapana = false;

$(function() {
	window.addEventListener('message', function(event) {
		
		if (event.data.type == 'showNUI'){
			$('html').css('display', 'block');
			document.getElementById('toChange').src = 'img/' + event.data.scratch + '.png';
			var amount = parseInt(event.data.component)
			if (amount == 0) {
				var textArray = [
					"NOT THIS TIME",
					"ES?",
					"BĘDZIE LEPIEJ",
					"MIŁEGO DNIA :)",
					"YAHA BRATKU",
					"CRY(ZONE)",
					"DAVID523",
					"BUZIACZKI",
					"WIEJSKA 13",
					"ZARÓB SOBIE",
					"ELO GAZELO",
					"LUTUJ GO!"
				];
				var randomNumber = Math.floor(Math.random()*textArray.length);
				document.getElementById("component").style.fontFamily = "Arial";
				document.getElementById('component').innerHTML = textArray[randomNumber];
			} else if (amount > 0) {
				document.getElementById("component").style.fontFamily = "Transistor";
				document.getElementById('component').innerHTML = amount + " $";
			}
			$('.layout').css('display', 'block');
			$('.compDiv').css('display', 'block');
		}
		
		var doc = document,
		cvs = doc.getElementById('j-cvs'), ctx,
		config = {
			w: 460, 
			h: 100
		},
		mouseDown = false;
		
		function getLocalCoords(elem, ev) {
			var ox = 0, oy = 0;
			var first;
			var pageX, pageY;
			while (elem != null) {
				ox += elem.offsetLeft;
				oy += elem.offsetTop;
				elem = elem.offsetParent;
			}
			if ("changedTouches" in ev) {
				first = ev.changedTouches[0];
				pageX = first.pageX;
				pageY = first.pageY;
			} else {
				pageX = ev.pageX;
				pageY = ev.pageY;
			}
			return { 'x': pageX - ox, 'y': pageY - oy };
		}
		
		function diffTransSize(cxt, threshold, callback){
			if (!'getImageData' in ctx) return;
			threshold = threshold || 0.5;
			if (threshold >1 || threshold < 0) threshold = 1;
			var imageData = ctx.getImageData(0, 0, cvs.width, cvs.height),
				pix = imageData.data,
				pixLength = pix.length,
				pixelSize = pixLength*0.25;
			var i = 1, k, l=0;
			for (; i <= pixelSize; i++) {
				if (0 === pix[4*i-1]) l++;
			};
			if (l>pixelSize * threshold) {
				callback.apply(ctx, [l]);
			};
			return;
		}
		
		function scratchLine(cvs, x, y, fresh) {
			ctx = cvs.getContext('2d');
			ctx.globalCompositeOperation = 'destination-out'; 

			ctx.lineWidth = 20;
			ctx.lineCap = ctx.lineJoin = 'round';
			ctx.strokeStyle = 'rgba(0,0,0,1)'; 
			if (fresh) {
				ctx.beginPath();
				ctx.moveTo(x+0.1, y);
			}
			ctx.lineTo(x, y);
			ctx.stroke();
			var style = cvs.style;
			style.lineHeight = style.lineHeight == '1' ? '1.1' : '1';

			diffTransSize(ctx, 0.8, function() {
				if (zdrapana == true)
					return;
				
				zdrapana = true;
				/*setTimeout(function(){
					zdrapana = false;
					$('.layout', 'html').hide();
					$('body').removeClass("active");
					$.post('http://flux_scratchcard/NUIFocusOff', JSON.stringify({}));
				}, 2000);*/
				return;
			});
		}
		
		function setupCanvases() {
			cvs.width = config.w;
			cvs.height = config.h;
			var ctx = cvs.getContext("2d");
			// add mask
			ctx.fillStyle = '#CCC';
			ctx.fillRect(0, 0, cvs.width, cvs.height);
			// On mouse down
			var mousedown_handler = function(e) {
				var local = getLocalCoords(cvs, e);
				mouseDown = true;
				scratchLine(cvs, local.x, local.y, true);
				if (e.cancelable) { e.preventDefault(); }
				return false;
			};
			// On mouse move
			var mousemove_handler = function(e) {
				if (!mouseDown) { return true; }
				var local = getLocalCoords(cvs, e);
				scratchLine(cvs, local.x, local.y, false);

				if (e.cancelable) { e.preventDefault(); }
				return false;
			};
			// On mouseup
			var mouseup_handler = function(e) {
				if (mouseDown) {
					mouseDown = false;
					if (e.cancelable) { e.preventDefault(); }
					return false;
				}
				return true;
			};
			on(cvs, 'mousedown', mousedown_handler);
			on(cvs, 'touchstart', mousedown_handler);
			on(window, 'mousemove', mousemove_handler);
			on(window, 'touchmove', mousemove_handler);
			on(window, 'mouseup', mouseup_handler);
			on(window, 'touchend', mouseup_handler);
		}
		function on(E, N, FN){
			E.addEventListener ? E.addEventListener(N, FN, !1) : E.attachEvent('on' + N, FN);
		}
		setupCanvases();
	});
});

document.onkeyup = function(data){
	if ((data.which == 8 || data.which == 27) && (zdrapana == true)){
		zdrapana = false;
		$('.layout', 'html').hide();
		$('.compDiv', 'html').hide();
		$('body').removeClass("active");
		$.post('http://exile_scratch/NUIFocusOff', JSON.stringify({}));
		return;
	}
}