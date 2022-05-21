let hideArmor = true;
let toggled = false;
let hidden = false;
let Compass = true;
let cinemamode = false;
let style = 'classic';
let crosshair = false;
let radio_activated = false;
let canchange = true;
let not = {
  default: true,
  twitter: true,
  lspdn: true,
};
let index = 0,
  toasts = [],
  maxOpened = 3;

function checkURL(url) {
  return url.match(/\.(jpeg|jpg|gif|png)$/) != null;
}

var settingss = window.localStorage.getItem('settings');
var settings = settingss
  ? JSON.parse(settingss)
  : {
      hp: rgbToHex(209, 0, 31),
      armor: rgbToHex(10, 89, 199),
      hunger: rgbToHex(0, 209, 56),
      thirst: rgbToHex(8, 135, 204),
      oxygen: rgbToHex(115, 143, 235),
      sound: rgbToHex(196, 190, 190),
      align: '2',
    };
var animations = {
  one: { bottom: '18px' },
  two: { bottom: '-80px' },
  three: { bottom: '0px' },
};

function resetSettings() {
  settings = {
    hp: rgbToHex(209, 0, 31),
    armor: rgbToHex(10, 89, 199),
    hunger: rgbToHex(0, 209, 56),
    thirst: rgbToHex(8, 135, 204),
    oxygen: rgbToHex(115, 143, 235),
    sound: rgbToHex(196, 190, 190),
    align: '2',
  };
  setAlign(settings.align);
  window.localStorage.setItem('settings', JSON.stringify(settings));
  $('#color1').val(settings.hp);
  $('#color2').val(settings.armor);
  $('#color3').val(settings.hunger);
  $('#color4').val(settings.thirst);
  $('#color5').val(settings.oxygen);
  $('#color6').val(settings.sound);
  $('#placement').val(settings.align);
}

function setAlign(t) {
  if (t == '2') {
    $('#thirst').css('transform', '');
    $('#hunger').css('transform', '');
    $('#sound').css('transform', '');
    $('.hud').css('right', '');
    $('.hud').css('top', '');
    $('.hud').css('transform', '');
    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('right', '');
    $('.hud-collapse').css('top', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-top-left-radius', '');
    $('.hud-collapse').css('border-bottom-left-radius', '');
    $('.radiol').css('top', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('bottom', '');
    $('.radior').css('border-radius', '');
    $('.radiol').css('right', '');
    $('.radiol').css('transform', '');
    $('.radior').css('right', '');
    $('.radior').css('transform', '');
    $('.hud').css('right', '');
    $('.hud').css('top', '');
    $('.hud').css('transform', '');
    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('top', '');
    $('.hud-collapse').css('right', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-bottom-left-radius', '');
    $('.hud-collapse').css('border-bottom-right-radius', '');
    $('.radiol').css('top', '');
    $('.radiol').css('transform', '');
    $('.radior').css('top', '');
    $('.radior').css('transform', '');
    $('.radiol').css('left', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('right', '');
    $('.radior').css('border-radius', '');
    $('.hud').css('left', '');
    $('.hud').css('top', '');
    $('.hud').css('transform', '');
    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('left', '');
    $('.hud-collapse').css('top', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-top-left-radius', '');
    $('.hud-collapse').css('border-bottom-left-radius', '');
    $('.radiol').css('left', '');
    $('.radiol').css('transform', '');
    $('.radior').css('left', '');
    $('.radior').css('transform', '');
    $('.radiol').css('top', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('bottom', '');
    $('.radior').css('border-radius', '');

    $('ul').css('display', '');
    $('li').css('display', '');
    $('ul').css('display', 'inline-block');
    $('li').css('display', 'inline-block');

    $('.hud').css('bottom', '');
    $('.hud').css('right', '');
    $('.hud').css('transform', '');
    $('.hud').css('bottom', '-80px');
    $('.hud').css('right', '50%');
    $('.hud').css('transform', 'translateX(50%)');

    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('bottom', '');
    $('.hud-collapse').css('right', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-top-left-radius', '');
    $('.hud-collapse').css('border-top-right-radius', '');
    $('.hud-collapse').css('width', '125px');
    $('.hud-collapse').css('height', '20px');
    $('.hud-collapse').css('bottom', '0');
    $('.hud-collapse').css('right', '50%');
    $('.hud-collapse').css('transform', 'translateX(50%)');
    $('.hud-collapse').css('border-top-left-radius', '5px');
    $('.hud-collapse').css('border-top-right-radius', '5px');

    $('.hud-collapse').html(
      '<span class="material-icons">arrow_drop_up</span>'
    );

    $('.radiol').css('bottom', '');
    $('.radiol').css('transform', '');
    $('.radior').css('bottom', '');
    $('.radior').css('transform', '');
    $('.radiol').css('bottom', '50%');
    $('.radiol').css('transform', 'translateY(50%)');
    $('.radior').css('bottom', '50%');
    $('.radior').css('transform', 'translateY(50%)');

    $('.radiol').css('left', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('right', '');
    $('.radior').css('border-radius', '');
    $('.radiol').css('left', '-30px');
    $('.radiol').css('border-radius', '15px 0 0 15px');
    $('.radior').css('right', '-30px');
    $('.radior').css('border-radius', '0 15px 15px 0');
    animations = {
      one: { bottom: '18px' },
      two: { bottom: '-80px' },
      three: { bottom: '0px' },
    };
  } else if (t == '1') {
    $('.hud').css('bottom', '');
    $('.hud').css('right', '');
    $('.hud').css('transform', '');
    $('.hud').css('bottom', '');
    $('.radiol').css('left', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('right', '');
    $('.radior').css('border-radius', '');
    $('.radiol').css('bottom', '');
    $('.radiol').css('transform', '');
    $('.radior').css('bottom', '');
    $('.radior').css('transform', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('bottom', '');
    $('.hud-collapse').css('right', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-top-left-radius', '');
    $('.hud-collapse').css('border-top-right-radius', '');
    $('.hud').css('right', '');
    $('.hud').css('top', '');
    $('.hud').css('transform', '');
    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('top', '');
    $('.hud-collapse').css('right', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-bottom-left-radius', '');
    $('.hud-collapse').css('border-bottom-right-radius', '');
    $('.radiol').css('top', '');
    $('.radiol').css('transform', '');
    $('.radior').css('top', '');
    $('.radior').css('transform', '');
    $('.radiol').css('left', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('right', '');
    $('.radior').css('border-radius', '');
    $('.hud').css('left', '');
    $('.hud').css('top', '');
    $('.hud').css('transform', '');
    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('left', '');
    $('.hud-collapse').css('top', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-top-left-radius', '');
    $('.hud-collapse').css('border-bottom-left-radius', '');
    $('.radiol').css('left', '');
    $('.radiol').css('transform', '');
    $('.radior').css('left', '');
    $('.radior').css('transform', '');
    $('.radiol').css('top', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('bottom', '');
    $('.radior').css('border-radius', '');

    $('ul').css('display', '');
    $('li').css('display', '');
    $('ul').css('display', 'block');
    $('li').css('display', 'block');

    $('.hud').css('right', '');
    $('.hud').css('top', '');
    $('.hud').css('transform', '');
    $('.hud').css('right', '-80px');
    $('.hud').css('top', '50%');
    $('.hud').css('transform', 'translateY(-50%)');

    $('#thirst').css('transform', '');
    $('#hunger').css('transform', '');
    $('#sound').css('transform', '');
    $('#thirst').css('transform', 'translateX(3px)');
    $('#hunger').css('transform', 'translateX(1px)');
    $('#sound').css('transform', 'translateX(3px)');

    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('right', '');
    $('.hud-collapse').css('top', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-top-left-radius', '');
    $('.hud-collapse').css('border-bottom-left-radius', '');
    $('.hud-collapse').css('height', '125px');
    $('.hud-collapse').css('width', '20px');
    $('.hud-collapse').css('right', '0');
    $('.hud-collapse').css('top', '50%');
    $('.hud-collapse').css('transform', 'translateY(-50%)');
    $('.hud-collapse').css('border-top-left-radius', '5px');
    $('.hud-collapse').css('border-bottom-left-radius', '5px');

    $('.hud-collapse').html('<span class="material-icons">arrow_left</span>');

    $('.radiol').css('right', '');
    $('.radiol').css('transform', '');
    $('.radior').css('right', '');
    $('.radior').css('transform', '');
    $('.radiol').css('right', '50%');
    $('.radiol').css('transform', 'translateX(50%)');
    $('.radior').css('right', '50%');
    $('.radior').css('transform', 'translateX(50%)');

    $('.radiol').css('top', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('bottom', '');
    $('.radior').css('border-radius', '');
    $('.radiol').css('top', '-40px');
    $('.radiol').css('border-radius', '15px 15px 0 0');
    $('.radior').css('bottom', '-40px');
    $('.radior').css('border-radius', '0 0 15px 15px');
    animations = {
      one: { right: '18px' },
      two: { right: '-80px' },
      three: { right: '0px' },
    };
  } else if (t == '3') {
    $('.hud').css('bottom', '');
    $('.hud').css('right', '');
    $('.hud').css('transform', '');
    $('.hud').css('bottom', '');
    $('.radiol').css('left', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('right', '');
    $('.radior').css('border-radius', '');
    $('.radiol').css('bottom', '');
    $('.radiol').css('transform', '');
    $('.radior').css('bottom', '');
    $('.radior').css('transform', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('bottom', '');
    $('.hud-collapse').css('right', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-top-left-radius', '');
    $('.hud-collapse').css('border-top-right-radius', '');
    $('.hud').css('right', '');
    $('.hud').css('top', '');
    $('.hud').css('transform', '');
    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('top', '');
    $('.hud-collapse').css('right', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-bottom-left-radius', '');
    $('.hud-collapse').css('border-bottom-right-radius', '');
    $('.radiol').css('top', '');
    $('.radiol').css('transform', '');
    $('.radior').css('top', '');
    $('.radior').css('transform', '');
    $('.radiol').css('left', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('right', '');
    $('.radior').css('border-radius', '');
    $('.hud').css('left', '');
    $('.hud').css('top', '');
    $('.hud').css('transform', '');
    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('left', '');
    $('.hud-collapse').css('top', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-top-left-radius', '');
    $('.hud-collapse').css('border-bottom-left-radius', '');
    $('.radiol').css('left', '');
    $('.radiol').css('transform', '');
    $('.radior').css('left', '');
    $('.radior').css('transform', '');
    $('.radiol').css('top', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('bottom', '');
    $('.radior').css('border-radius', '');

    $('ul').css('display', '');
    $('li').css('display', '');
    $('ul').css('display', 'inline-block');
    $('li').css('display', 'inline-block');

    $('.hud').css('right', '');
    $('.hud').css('top', '');
    $('.hud').css('transform', '');
    $('.hud').css('top', '-80px');
    $('.hud').css('right', '50%');
    $('.hud').css('transform', 'translateX(50%)');

    $('#thirst').css('transform', '');
    $('#hunger').css('transform', '');
    $('#sound').css('transform', '');

    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('top', '');
    $('.hud-collapse').css('right', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-bottom-left-radius', '');
    $('.hud-collapse').css('border-bottom-right-radius', '');
    $('.hud-collapse').css('height', '20px');
    $('.hud-collapse').css('width', '125px');
    $('.hud-collapse').css('top', '0');
    $('.hud-collapse').css('right', '50%');
    $('.hud-collapse').css('transform', 'translateX(50%)');
    $('.hud-collapse').css('border-bottom-left-radius', '5px');
    $('.hud-collapse').css('border-bottom-right-radius', '5px');

    $('.hud-collapse').html(
      '<span class="material-icons">arrow_drop_down</span>'
    );

    $('.radiol').css('top', '');
    $('.radiol').css('transform', '');
    $('.radior').css('top', '');
    $('.radior').css('transform', '');
    $('.radiol').css('top', '50%');
    $('.radiol').css('transform', 'translateY(-50%)');
    $('.radior').css('top', '50%');
    $('.radior').css('transform', 'translateY(-50%)');

    $('.radiol').css('left', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('right', '');
    $('.radior').css('border-radius', '');
    $('.radiol').css('left', '-30px');
    $('.radiol').css('border-radius', '15px 0 0 15px');
    $('.radior').css('right', '-30px');
    $('.radior').css('border-radius', '0 15px 15px 0');
    animations = {
      one: { top: '18px' },
      two: { top: '-80px' },
      three: { top: '0px' },
    };
  } else if (t == '4') {
    $('.hud').css('bottom', '');
    $('.hud').css('right', '');
    $('.hud').css('transform', '');
    $('.hud').css('bottom', '');
    $('.radiol').css('left', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('right', '');
    $('.radior').css('border-radius', '');
    $('.radiol').css('bottom', '');
    $('.radiol').css('transform', '');
    $('.radior').css('bottom', '');
    $('.radior').css('transform', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('bottom', '');
    $('.hud-collapse').css('right', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-top-left-radius', '');
    $('.hud-collapse').css('border-top-right-radius', '');
    $('.hud').css('right', '');
    $('.hud').css('top', '');
    $('.hud').css('transform', '');
    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('top', '');
    $('.hud-collapse').css('right', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-bottom-left-radius', '');
    $('.hud-collapse').css('border-bottom-right-radius', '');
    $('.radiol').css('top', '');
    $('.radiol').css('transform', '');
    $('.radior').css('top', '');
    $('.radior').css('transform', '');
    $('.radiol').css('left', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('right', '');
    $('.radior').css('border-radius', '');

    $('ul').css('display', '');
    $('li').css('display', '');
    $('ul').css('display', 'block');
    $('li').css('display', 'block');

    $('.hud').css('left', '');
    $('.hud').css('top', '');
    $('.hud').css('transform', '');
    $('.hud').css('left', '-80px');
    $('.hud').css('top', '50%');
    $('.hud').css('transform', 'translateY(-50%)');

    $('#thirst').css('transform', '');
    $('#hunger').css('transform', '');
    $('#sound').css('transform', '');
    $('#thirst').css('transform', 'translateX(3px)');
    $('#hunger').css('transform', 'translateX(1px)');
    $('#sound').css('transform', 'translateX(3px)');

    $('.hud-collapse').css('height', '');
    $('.hud-collapse').css('width', '');
    $('.hud-collapse').css('left', '');
    $('.hud-collapse').css('top', '');
    $('.hud-collapse').css('transform', '');
    $('.hud-collapse').css('border-top-right-radius', '');
    $('.hud-collapse').css('border-bottom-right-radius', '');
    $('.hud-collapse').css('height', '125px');
    $('.hud-collapse').css('width', '20px');
    $('.hud-collapse').css('left', '0');
    $('.hud-collapse').css('top', '50%');
    $('.hud-collapse').css('transform', 'translateY(-50%)');
    $('.hud-collapse').css('border-top-right-radius', '5px');
    $('.hud-collapse').css('border-bottom-right-radius', '5px');

    $('.hud-collapse').html('<span class="material-icons">arrow_right</span>');

    $('.radiol').css('left', '');
    $('.radiol').css('transform', '');
    $('.radior').css('left', '');
    $('.radior').css('transform', '');
    $('.radiol').css('left', '50%');
    $('.radiol').css('transform', 'translateX(-50%)');
    $('.radior').css('left', '50%');
    $('.radior').css('transform', 'translateX(-50%)');

    $('.radiol').css('top', '');
    $('.radiol').css('border-radius', '');
    $('.radior').css('bottom', '');
    $('.radior').css('border-radius', '');
    $('.radiol').css('top', '-40px');
    $('.radiol').css('border-radius', '15px 15px 0 0');
    $('.radior').css('bottom', '-40px');
    $('.radior').css('border-radius', '0 0 15px 15px');
    animations = {
      one: { left: '18px' },
      two: { left: '-80px' },
      three: { left: '0px' },
    };
  }
}

setTimeout(() => {
  window.localStorage.setItem('settings', JSON.stringify(settings));
  setAlign(settings.align);
}, 1000);
function hide() {
  if (hidden) {
    hidden = false;
    $('.hud').fadeIn(300);
    $('.hud-collapse').fadeIn(300);
  } else {
    hidden = true;
    $('.hud').fadeOut(300);
    $('.hud-collapse').fadeOut(300);
  }
}

function maxLengthCheck(object) {
  if (object.value.length > object.maxLength)
    object.value = object.value.slice(0, object.maxLength);
}

function exit() {
  $('.containerx').fadeOut(300);
  $.post('https://css_hud/NUIFocusOff', JSON.stringify({}));
}

$(document).on('keyup', function (e) {
  if (e.key == 'Escape') {
    exit();
  }
});

function saveSettings() {
  settings.hp = $('#color1').val();
  settings.armor = $('#color2').val();
  settings.hunger = $('#color3').val();
  settings.thirst = $('#color4').val();
  settings.oxygen = $('#color5').val();
  settings.sound = $('#color6').val();
  settings.align = $('#placement').val();
  setAlign(settings.align);
  window.localStorage.setItem('settings', JSON.stringify(settings));
}

var switchh = true;

window.addEventListener('message', (event) => {
  if (event.data.type == 'SET_SETTINGS') {
    if (event.data.hidden) {
      if (event.data.hidden == 'true') {
        hidden = true;
        $('.hud').hide();
        $('.hud-collapse').hide();
      } else {
        if (event.data.cinema !== 'true') {
          $('.hud').show();
          $('.hud-collapse').show();
          hidden = false;
        }
      }
    }
    if (event.data.carhudstylex) {
      switch (event.data.carhudstylex) {
        case 'classic':
          style = 'classic';
          break;
      }
    }
  }
  if (event.data.type == 'OPEN_SETTINGS') {
    $('#color1').val(settings.hp);
    $('#color2').val(settings.armor);
    $('#color3').val(settings.hunger);
    $('#color4').val(settings.thirst);
    $('#color5').val(settings.oxygen);
    $('#color6').val(settings.sound);
    $('#placement').val(settings.align);
    $('.containerx').fadeIn(300);
  }
  if (event.data.type == 'TOGGLE_HUD') {
    if (toggled) {
      toggled = false;
      $('.hud').animate(animations.two, 300);
      setTimeout(function () {
        if (!toggled) {
          $('.hud-collapse').animate(animations.three, 300);
          if ($('.radiol').hasClass('mm_visible')) {
            $('.radiol').removeClass('mm_visible');
            $('.radiol').fadeOut(300);
          }
          if ($('.radior').hasClass('mm_visible')) {
            $('.radior').removeClass('mm_visible');
            $('.radior').fadeOut(300);
          }
        }
      }, 500);
    } else {
      toggled = true;
      $('.hud-collapse').animate(animations.two, 300);
      setTimeout(function () {
        if (toggled) {
          $('.hud').animate(animations.one, 300);
          if (radio_activated) {
            $('.radiol').addClass('mm_visible');
            $('.radiol').fadeIn(300);
            $('.radior').addClass('mm_visible');
            $('.radior').fadeIn(300);
          }
        }
      }, 500);
    }
    return;
  }

  if (event.data.type == 'UPDATE_VOICE') {
    if (event.data.isTalking) {
      if (event.data.mode == 'Car') {
        $('#grad7').html(
          '<stop offset="0%" style="stop-color:rgb(79, 75, 75);stop-opacity:1" /><stop offset="25%" style="stop-color:rgb(54, 50, 50);stop-opacity:1"/><stop offset="25%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
        );
      } else if (event.data.mode == 'Whisper') {
        $('#grad7').html(
          '<stop offset="0%" style="stop-color:rgb(79, 75, 75);stop-opacity:1" /><stop offset="50%" style="stop-color:rgb(54, 50, 50);stop-opacity:1"/><stop offset="50%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
        );
      } else if (event.data.mode == 'Normal') {
        $('#grad7').html(
          '<stop offset="0%" style="stop-color:rgb(79, 75, 75);stop-opacity:1" /><stop offset="75%" style="stop-color:rgb(54, 50, 50);stop-opacity:1"/><stop offset="75%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
        );
      } else if (event.data.mode == 'Shouting') {
        $('#grad7').html(
          '<stop offset="0%" style="stop-color:rgb(79, 75, 75);stop-opacity:1" /><stop offset="100%" style="stop-color:rgb(54, 50, 50);stop-opacity:1"/><stop offset="100%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
        );
      }
    } else {
      if (event.data.mode == 'Car') {
        $('#grad7').html(
          '<stop offset="0%" style="stop-color:' +
            settings.sound +
            ';stop-opacity:1" /><stop offset="25%" style="stop-color:' +
            settings.sound +
            ';stop-opacity:1"/><stop offset="25%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
        );
      } else if (event.data.mode == 'Whisper') {
        $('#grad7').html(
          '<stop offset="0%" style="stop-color:' +
            settings.sound +
            ';stop-opacity:1" /><stop offset="50%" style="stop-color:' +
            settings.sound +
            ';stop-opacity:1"/><stop offset="50%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
        );
      } else if (event.data.mode == 'Normal') {
        $('#grad7').html(
          '<stop offset="0%" style="stop-color:' +
            settings.sound +
            ';stop-opacity:1" /><stop offset="75%" style="stop-color:' +
            settings.sound +
            ';stop-opacity:1"/><stop offset="75%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
        );
      } else if (event.data.mode == 'Shouting') {
        $('#grad7').html(
          '<stop offset="0%" style="stop-color:' +
            settings.sound +
            ';stop-opacity:1" /><stop offset="100%" style="stop-color:' +
            settings.sound +
            ';stop-opacity:1"/><stop offset="100%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
        );
      }
    }
    return;
  }
  if (event.data.type == 'SWITCH_DISPLAY') {
    if (switchh && canchange) {
      $('html').fadeOut(500);
      switchh = false;
    } else {
      if (canchange) {
        $('html').fadeIn(500);
        switchh = true;
      }
    }
  }
  if (event.data.type == 'SWITCH_HUD') {
    if (event.data.mode) {
      $('html').fadeOut(500);
      window.localStorage.setItem('hud', 'old');
    } else {
      $('html').fadeIn(500);
      window.localStorage.setItem('hud', 'new');
    }
  }
  if (event.data.type == 'SWITCH_VISIBILITY') {
    if (event.data.bool) {
      window.localStorage.setItem('hud', 'new');
    } else {
      window.localStorage.setItem('hud', 'old');
    }
    if (event.data.bool) {
      $('html').fadeIn(500);
      canchange = true;
    } else {
      $('html').fadeOut(500);
      canchange = false;
    }
  }
  if (event.data.type == 'UPDATE_HUD') {
    if (event.data.hunger) {
      var hungerlevel = Math.floor(event.data.hunger);
      $('#grad3').html(
        '<stop offset="0%" style="stop-color:' +
          settings.hunger +
          ';stop-opacity:1" /><stop offset="' +
          hungerlevel +
          '%" style="stop-color:' +
          settings.hunger +
          ';stop-opacity:1" /><stop offset="' +
          hungerlevel +
          '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
      );
    }
    if (event.data.thirst) {
      var thirstlevel = Math.floor(event.data.thirst);
      $('#grad4').html(
        '<stop offset="0%" style="stop-color:' +
          settings.thirst +
          ';stop-opacity:1" /><stop offset="' +
          thirstlevel +
          '%" style="stop-color:' +
          settings.thirst +
          ';stop-opacity:1" /><stop offset="' +
          thirstlevel +
          '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
      );
    }
    if (event.data.armor) {
      var armorlevel = Math.floor(event.data.armor);
      $('#grad2').html(
        '<stop offset="0%" style="stop-color:' +
          settings.armor +
          ';stop-opacity:1" /><stop offset="' +
          armorlevel +
          '%" style="stop-color:' +
          settings.armor +
          ';stop-opacity:1" /><stop offset="' +
          armorlevel +
          '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
      );
    }
    if (event.data.armor <= 0) {
      $('#armor').fadeOut(1000);
    }
    if (event.data.armor > 0) {
      $('#armor').fadeIn(1000);
    }
    if (event.data.nurkowanie) {
      var oxygenlevel = Math.floor(event.data.nurkowanie);
      $('#grad5').html(
        '<stop offset="0%" style="stop-color:' +
          settings.oxygen +
          ';stop-opacity:1" /><stop offset="' +
          oxygenlevel +
          '%" style="stop-color:' +
          settings.oxygen +
          ';stop-opacity:1" /><stop offset="' +
          oxygenlevel +
          '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
      );
    }
    if (event.data.inwater) {
      $('#oxygen').fadeIn(1000);
    }
    if (!event.data.inwater) {
      $('#oxygen').fadeOut(1000);
    }
    if (event.data.stress <= 1) {
      $('#stress').fadeOut(1000);
    }
    if (event.data.stress > 1) {
      $('#stress').fadeIn(1000);
    }
    // if (event.data.stress) {
    // 	var stress = Math.floor(event.data.stress / 10)
    // 	$('#grad6').html('<stop offset="' + stress + '%" style="stop-color:rgb(142, 84, 233);stop-opacity:1" /><stop offset="' + stress + '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
    // }
    if (event.data.zycie) {
      var hplevel = Math.floor(event.data.zycie);
      $('#grad1').html(
        '<stop offset="0%" style="stop-color:' +
          settings.hp +
          ';stop-opacity:1" /><stop offset="' +
          hplevel +
          '%" style="stop-color:' +
          settings.hp +
          ';stop-opacity:1" /><stop offset="' +
          hplevel +
          '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
      );
    }
    if (event.data.isdead) {
      $('#grad1').html(
        '<stop offset="0%" style="stop-color:' +
          settings.hp +
          ';stop-opacity:1" /><stop offset="0%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>'
      );
    }
    return;
  }
  if (event.data.showradio == true) {
    if (!$('.radiol').hasClass('mm_visible')) {
      $('.radiol').addClass('mm_visible');
      $('.radiol').fadeIn(300);
    }
    if (!$('.radior').hasClass('mm_visible')) {
      $('.radior').addClass('mm_visible');
      $('.radior').fadeIn(300);
    }
    radio_activated = true;
  }
  if (event.data.hideradio == true) {
    if ($('.radiol').hasClass('mm_visible')) {
      $('.radiol').removeClass('mm_visible');
      $('.radiol').fadeOut(300);
    }
    if ($('.radior').hasClass('mm_visible')) {
      $('.radior').removeClass('mm_visible');
      $('.radior').fadeOut(300);
    }
    radio_activated = false;
  }
  if (event.data.radionumber) {
    $('.radionumber').text(event.data.radionumber);
  }
  if (event.data.radiocount) {
    $('.radiopeople').text(event.data.radiocount);
  }
});

function componentToHex(c) {
  var hex = c.toString(16);
  return hex.length == 1 ? '0' + hex : hex;
}

function rgbToHex(r, g, b) {
  return '#' + componentToHex(r) + componentToHex(g) + componentToHex(b);
}

window.addEventListener('load', (event) => {
  $('#help').fadeOut(0);
});
0;
