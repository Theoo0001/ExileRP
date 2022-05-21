window.addEventListener("message", function(event) {
	var data = event.data
	
	switch(data.action) {
		case 'initHud':
			reBuildCarHud()
		break;
		
		case 'setVehicle': 
			if (data.state == true) {				
				$('#carhud').fadeIn()
			} else {
				$('#carhud').fadeOut()
			}		
		break;
			
		case 'setBelt':			
			SetBelt(data.state)
		break;
		
		case 'setDirection':
			if (data.direction != undefined) {
				$('#Street2').text(data.direction)
			}
			
			if (data.distance != undefined) {
				$('#Street1').text(data.distance)
			}
		break;
		
		case 'setStateDirection':
			if (data.state == true) {
				$('#streetlabel').fadeIn()
			} else if (data.state == false) {
				$('#streetlabel').fadeOut()
			}
			
			console.log(data.state)
		break;
		
		case 'setKmh':
			SetSpeed(data.kmh, data.rpm)
			
			if (data.gear) {				
				$('#geartext').text(data.gear)
			}		
		break;
		
	}
});

function SetBelt(value) {
	var percent = 0
	var belt = document.querySelector('.belt')
	
	if (value == true) {
		percent = 75
		belt.src = "img/belt_on.png";
	} else if (value == false) {
		belt.src = "img/belt_off.png";
	}

    var circle = document.querySelector('.progress-belt');	
    var radius = circle.r.baseVal.value;	
    var circumference = radius * 2 * Math.PI;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent * 99) / 100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;
}

function SetSpeed(value, rpm) {
    var circle = document.querySelector('.progress-speed');
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-rpm*73)/100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

	$('#speedtext').text(value);
}


function setProgressZentih(value, element) {	
    var circle = document.querySelector(element);	
    var radius = circle.r.baseVal.value;	
	
    var circumference = radius * 2 * Math.PI;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-value * 99) / 100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;
}

var reBuildFinish = false;
function reBuildCarHud() { 	
	if (reBuildFinish != true) {
		setTimeout(function() {
			var circle = document.querySelector('.progress-maxspeed');	
			var radius = circle.r.baseVal.value;	
			
			var circumference = radius * 2 * Math.PI;

			circle.style.strokeDasharray = `${circumference} ${circumference}`;
			circle.style.strokeDashoffset = `${circumference}`;

			const offset = circumference - ((-64 * 99) / 100) / 100 * circumference;
			circle.style.strokeDashoffset = -offset;	   

			var circle2 = document.querySelector('.progress-belt');	
			var radius = circle2.r.baseVal.value;	
			
			var circumference2 = radius * 2 * Math.PI;

			circle2.style.strokeDasharray = `${circumference2} ${circumference2}`;
			circle2.style.strokeDashoffset = `${circumference2}`;

			const offset2 = circumference2 - ((-0 * 99) / 100) / 100 * circumference2;
			circle2.style.strokeDashoffset = -offset2;		
			
			var circle3 = document.querySelector('.progress-belt2');	
			var radius = circle3.r.baseVal.value;	
			
			var circumference3 = radius * 2 * Math.PI;

			circle3.style.strokeDasharray = `${circumference3} ${circumference3}`;
			circle3.style.strokeDashoffset = `${circumference3}`;

			const offset3 = circumference3 - ((-75 * 99) / 100) / 100 * circumference3;
			circle3.style.strokeDashoffset = -offset3;	
			
			if (circumference == 0.0 || circumference2 == 0.0 || circumference3 == 0.0) {
				reBuildCarHud()
			} else {
				reBuildFinish = true
			}
		}, 3000);
	}
}