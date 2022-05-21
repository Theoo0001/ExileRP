let block = false;
let engineOn = false;
let speedoMode = 1;
setTimeout(() => {
  if (window.localStorage.getItem('hud') != undefined) {
    if (window.localStorage.getItem('hud') != 'new') {
      $.post('https://css_hud/sethud', JSON.stringify({ mode: true }));
      $('html').fadeOut(500);
    } else {
      $.post('https://css_hud/sethud', JSON.stringify({ mode: false }));
    }
  } else {
    $.post('https://css_hud/sethud', JSON.stringify({ mode: false }));
    window.localStorage.setItem('hud', 'new');
  }
}, 1000);

$(document).ready(function () {
  $('.speedometer').hide();
  $('.mapborder').hide();
  window.addEventListener('message', function (event) {
    if (event.data.switchhud) {
      speedoMode = speedoMode == 1 ? 2 : 1;
      window.localStorage.setItem('hud', speedoMode == 1 ? 'new' : 'old');
    }
    if (event.data.showhud == true && !block) {
      $('.streetlabel').css('display', 'inline-flex');
      if (speedoMode == 1) {
        $('.speedometer').show();
        $('.speedometer-minimalistic').hide();
        $('.streetlabel').removeClass('streetminimalist');
      } else {
        $('.streetlabel').addClass('streetminimalist');
        $('.speedometer-minimalistic').css('display', 'inline-flex');
        $('.speedometer').hide();
      }
      engineOn = true;
    }
    if (event.data.showhud == false && !block) {
      $('.streetlabel').hide();
      $('.speedometer').hide();
      $('.speedometer-minimalistic').hide();
      $('.speedometer').hide();
      engineOn = false;
    }

    if (event.data.type == 'SWITCH_SPEEDO') {
      if (event.data.bool) {
        block = true;
        $('.speedometer').hide();
        engineOn = false;
      } else {
        block = false;
      }
    }

    if (event.data.style) {
      if (engineOn == true) {
        if (speedoMode == 1) {
          $('.streetlabel').removeClass('streetminimalist');
          $('.speedometer').show();
          $('.speedometer-minimalistic').hide();
        } else {
          $('.streetlabel').addClass('streetminimalist');
          $('.speedometer-minimalistic').css('display', 'inline-flex');
          $('.speedometer').hide();
        }
      }
    }

    if (event.data.aspectratio) {
      setAspectRatio(Math.round(event.data.aspectratio * 100) / 100);
    }

    if (event.data.speedometer) {
      let speed = Number(event.data.speed);
      let percent = Number(event.data.percent);
      let showpercent = percent * 0.82;
      if (speed < 10) {
        $('.speed-digital').text('00' + speed);
        $('.minimalistic-speed').text('00' + speed + ' km/h');
      } else if (speed < 100) {
        $('.speed-digital').text('0' + speed);
        $('.minimalistic-speed').text('0' + speed + ' km/h');
      } else {
        $('.speed-digital').text(speed);
        $('.minimalistic-speed').text(speed + ' km/h');
      }

      $('.speed').attr('stroke-dasharray', showpercent + ' 100');
    }
    if (event.data.tachometer) {
      let gear = event.data.gear;
      if (gear == '0') gear = 'R';
      $('.gear').html(gear);

      if (event.data.eHealth > 900) {
        $('.speed').css('stroke', 'rgba(52, 145, 23, 0.9)');
      } else if (event.data.eHealth > 700) {
        $('.speed').css('stroke', 'rgba(65, 222, 16, 0.9)');
      } else if (event.data.eHealth > 500) {
        $('.speed').css('stroke', 'rgba(231, 235, 19, 0.9)');
      } else if (event.data.eHealth > 400) {
        $('.speed').css('stroke', 'rgba(217, 133, 15, 0.9)');
      } else if (event.data.eHealth > 300) {
        $('.speed').css('stroke', 'rgba(224, 33, 16, 0.9)');
      } else if (event.data.eHealth > 200) {
        $('.speed').css('stroke', 'rgba(173, 32, 19, 0.9)');
      } else if (event.data.eHealth > 100) {
        $('.speed').css('stroke', 'rgba(145, 32, 22, 0.9)');
      } else {
        $('.speed').css('stroke', 'rgba(94, 21, 14, 0.9)');
      }

      let rpm = Number(event.data.rpmx) * 0.65;
      $('.tacho path').attr('stroke-dasharray', rpm + ' 100');
    }
    if (event.data.lights) {
      let lightlevel = Number(event.data.lights);

      if (lightlevel == 2) {
        $('.lights').attr('fill', 'rgba(252, 211, 3, 0.5)');
      } else if (lightlevel == 3) {
        $('.lights').attr('fill', 'rgb(252, 211, 3)');
      } else {
        $('.lights').attr('fill', 'rgb(255, 255, 255)');
      }
    }

    if (event.data.seatbelt) {
      $('.seatbelt').addClass('active');
      $('.seatbelt .ikona').css('fill', 'rgba(0, 255, 0, 0.9)');
    } else if (event.data.seatbelt == false) {
      $('.seatbelt').removeClass('active');
      $('.seatbelt .ikona').css('fill', 'rgba(255, 0, 0, 0.9)');
    }

    if (event.data.street) {
      $('.street').text(event.data.street);
    }
    if (event.data.direction) {
      $('.direction').text(event.data.direction);
    }
  });

  function setAspectRatio(x) {
    $('body').removeClass();
    if (x == 1.5) {
      $('body').addClass('threetwo');
    } else if (x == 1.33) {
      $('body').addClass('fourthree');
    } else if (x == 1.67) {
      $('body').addClass('fivethree');
    } else if (x == 1.67) {
      $('body').addClass('fivethree');
    } else if (x == 1.25) {
      $('body').addClass('fivefour');
    } else if (x == 1.6) {
      $('body').addClass('sixteenten');
    }
  }
});

$('.huds').hide();
$('.mapborder').hide();
