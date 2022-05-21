const phone = document.getElementById('phone')
const alertNoti = document.querySelector('.alert')
const soundNoti = document.getElementById('audio')
const colorPicker = document.querySelector('.colorpicker')

let dragHealthTop, dragHealthLeft, dragArmorTop, dragArmorLeft, dragStaminaTop, dragStaminaLeft, dragOxygenTop, dragOxygenLeft, dragMicTop, dragMicLeft, dragHungerTop, dragHungerLeft, dragThirstTop, dragThirstLeft;
dragHealthTop = dragHealthLeft = dragArmorTop = dragArmorLeft = dragStaminaTop = dragStaminaLeft = dragOxygenTop = dragOxygenLeft = dragMicTop = dragMicLeft = dragHungerTop = dragHungerLeft = dragThirstTop = dragThirstLeft = 0;

// Dark mode
document.querySelector('.invert-btn').addEventListener('click', () => {
    document.body.classList.toggle('dark-mode');
});

// Show and hide phone
window.addEventListener("message", function(event) {
    switch (event.data.action) {
        case "show":
            $("#phone").show();
        break;
    }
})

document.querySelector('.image-exit').addEventListener('click', () => {
    $("#phone").fadeOut();
    $.post('https://exile_hud/close');
    setTimeout(function() {
        phone.style.animation = "none"
    }, 400)
});

document.onkeyup = function (event) {
    if (event.key == 'Escape') {
        $("#phone").fadeOut();
        $.post('https://exile_hud/close');
        setTimeout(function() {
            phone.style.animation = "none"
        }, 400)
    }
};

// Notification for saving
document.querySelector('.accept-button').addEventListener('click', () => {
    soundNoti.play();
	
	// Save all position data
	localStorage.setItem("dragHealthTop", dragHealthTop);
	localStorage.setItem("dragHealthLeft", dragHealthLeft);

	localStorage.setItem("dragArmorTop", dragArmorTop);
	localStorage.setItem("dragArmorLeft", dragArmorLeft);

	localStorage.setItem("dragStaminaTop", dragStaminaTop);
	localStorage.setItem("dragStaminaLeft", dragStaminaLeft);

	localStorage.setItem("dragOxygenTop", dragOxygenTop);
	localStorage.setItem("dragOxygenLeft", dragOxygenLeft);

	localStorage.setItem("dragMicTop", dragMicTop);
	localStorage.setItem("dragMicLeft", dragMicLeft);

	localStorage.setItem("dragHungerTop", dragHungerTop);
	localStorage.setItem("dragHungerLeft", dragHungerLeft);

	localStorage.setItem("dragThirstTop", dragThirstTop);
	localStorage.setItem("dragThirstLeft", dragThirstLeft);


	// Save sliders data
	localStorage.setItem("sliderHealth", health)
	localStorage.setItem("sliderArmor", armor)
	localStorage.setItem("sliderStamina", stamina)
	localStorage.setItem("sliderOxygen", oxygen)
	localStorage.setItem("sliderMic", mic)
	localStorage.setItem("sliderCinematic", cinematic)
	localStorage.setItem("sliderHunger", hunger)
	localStorage.setItem("sliderThirst", thirst)
});

document.getElementById('reset-color').addEventListener('click', () => {
    soundNoti.play();

	$('#health-circle').css('stroke', '');
	localStorage.setItem("healthColor", '');
	$('#armor-circle').css('stroke', '');
	localStorage.setItem("armorColor", '');
	$('#stamina-circle').css('stroke', '');
	localStorage.setItem("staminaColor", '');
	$('#oxygen-circle').css('stroke', '');
	localStorage.setItem("oxygenColor", '');
	$('#microphone-circle').css('stroke', '');
	localStorage.setItem("microphoneColor", '');
	$('#hunger-circle').css('stroke', '');
	localStorage.setItem("hungerColor", '');
	$('#thirst-circle').css('stroke', '');
	localStorage.setItem("thirstColor", '');
	colorPicker.value = rgb2hex($('#health-circle').css('stroke'))
});

document.getElementById('reset-position').addEventListener('click', () => {
    soundNoti.play();
	
	$("#health").animate({ top: "0px", left: "0px"});
	localStorage.setItem("dragHealthTop", "0px");
	localStorage.setItem("dragHealthLeft", "0px");
	$("#armor").animate({ top: "0px", left: "0px" });
	localStorage.setItem("dragArmorTop", "0px");
	localStorage.setItem("dragArmorLeft", "0px");
	$("#stamina").animate({ top: "0px", left: "0px" });
	localStorage.setItem("dragStaminaTop", "0px");
	localStorage.setItem("dragStaminaLeft", "0px");
	$("#oxygen").animate({ top: "0px", left: "0px" });
	localStorage.setItem("dragOxygenTop", "0px");
	localStorage.setItem("dragOxygenLeft", "0px");
	$("#microphone").animate({ top: "0px", left: "0px" });
	localStorage.setItem("dragMicTop", "0px");
	localStorage.setItem("dragMicLeft", "0px");
	$("#hunger").animate({top: "0px", left: "0px"});
	localStorage.setItem("dragHungerTop", "0px");
	localStorage.setItem("dragHungerLeft", "0px");
	$("#thirst").animate({top: "0px", left: "0px"});
	localStorage.setItem("dragThirstTop", "0px");
	localStorage.setItem("dragThirstLeft", "0px");	
});

// Record the position
$("#health").on("dragstop", function(event, ui) {
    dragHealthTop = ui.position.top;
    dragHealthLeft = ui.position.left;
});

$("#armor").on("dragstop", function(event, ui) {
    dragArmorTop = ui.position.top;
    dragArmorLeft = ui.position.left;
});

$("#stamina").on("dragstop", function(event, ui) {
    dragStaminaTop = ui.position.top;
    dragStaminaLeft = ui.position.left;
});

$("#oxygen").on("dragstop", function(event, ui) {
    dragOxygenTop = ui.position.top;
    dragOxygenLeft = ui.position.left;
});

$("#microphone").on("dragstop", function(event, ui) {
    dragMicTop = ui.position.top;
    dragMicLeft = ui.position.left;
});

$("#hunger").on("dragstop", function(event, ui) {
	dragHungerTop = ui.position.top;
	dragHungerLeft = ui.position.left;
});

$("#thirst").on("dragstop", function(event, ui) {
	dragThirstTop = ui.position.top;
	dragThirstLeft = ui.position.left;
});