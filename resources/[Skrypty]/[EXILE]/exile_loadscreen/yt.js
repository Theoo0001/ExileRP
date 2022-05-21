var _0x31de0e = _0x5613;
(function (_0x1257de, _0x8cc12c) {
  var _0x50f90c = _0x5613,
    _0x1e9a85 = _0x1257de();
  while (!![]) {
    try {
      var _0x108294 =
        -parseInt(_0x50f90c(0x148)) / 0x1 +
        parseInt(_0x50f90c(0x150)) / 0x2 +
        (parseInt(_0x50f90c(0x136)) / 0x3) *
          (-parseInt(_0x50f90c(0x13d)) / 0x4) +
        (parseInt(_0x50f90c(0x14f)) / 0x5) *
          (-parseInt(_0x50f90c(0x14e)) / 0x6) +
        (-parseInt(_0x50f90c(0x141)) / 0x7) *
          (parseInt(_0x50f90c(0x13e)) / 0x8) +
        parseInt(_0x50f90c(0x156)) / 0x9 +
        (-parseInt(_0x50f90c(0x145)) / 0xa) *
          (-parseInt(_0x50f90c(0x134)) / 0xb);
      if (_0x108294 === _0x8cc12c) break;
      else _0x1e9a85['push'](_0x1e9a85['shift']());
    } catch (_0x107aa0) {
      _0x1e9a85['push'](_0x1e9a85['shift']());
    }
  }
})(_0x539e, 0x5bbca);
var tag = document['createElement'](_0x31de0e(0x155));
tag[_0x31de0e(0x152)] = _0x31de0e(0x14c);
var firstScriptTag = document[_0x31de0e(0x154)](_0x31de0e(0x155))[0x0];
firstScriptTag['parentNode'][_0x31de0e(0x135)](tag, firstScriptTag);
const lastSong = localStorage[_0x31de0e(0x158)](_0x31de0e(0x14d));
var player;
function onYouTubeIframeAPIReady() {
  var _0x553c9c = _0x31de0e;
  player = new YT[_0x553c9c(0x13b)](_0x553c9c(0x15b), {
    height: _0x553c9c(0x14a),
    width: _0x553c9c(0x15c),
    playerVars: { controls: 0x0, loop: 0x1 },
    videoId: 'ewJM7RsFu2A',
    events: { onReady: onPlayerReady, onStateChange: onPlayerStateChange },
  });
}
function onPlayerReady(_0x4e3260) {
  setTimeout(() => {
    var _0x5015b3 = _0x5613;
    _0x4e3260[_0x5015b3(0x15e)][_0x5015b3(0x15d)]();
  }, 0x64);
}
var done = ![];
function onPlayerStateChange(_0x1fcbc7) {
  var _0x7ba0c5 = _0x31de0e;
  if (
    _0x1fcbc7[_0x7ba0c5(0x157)] == YT['PlayerState'][_0x7ba0c5(0x143)] &&
    !done
  )
    done = !![];
  else
    _0x1fcbc7[_0x7ba0c5(0x157)] == YT[_0x7ba0c5(0x140)][_0x7ba0c5(0x15a)] &&
      (player[_0x7ba0c5(0x144)](0x0), player[_0x7ba0c5(0x15d)]());
}
function stopVideo() {
  var _0x470d5a = _0x31de0e;
  player[_0x470d5a(0x153)]();
}
var player1;
const input = document[_0x31de0e(0x139)](_0x31de0e(0x138));
function _0x5613(_0x2e8ff2, _0x157330) {
  var _0x539e97 = _0x539e();
  return (
    (_0x5613 = function (_0x561353, _0x3128d9) {
      _0x561353 = _0x561353 - 0x132;
      var _0xdffe86 = _0x539e97[_0x561353];
      return _0xdffe86;
    }),
    _0x5613(_0x2e8ff2, _0x157330)
  );
}
if (lastSong) input[_0x31de0e(0x142)] = lastSong;
(window[_0x31de0e(0x151)] = () => {
  if (lastSong) playAudio();
}),
  input[_0x31de0e(0x149)](_0x31de0e(0x14b), function (_0x297d20) {
    var _0x374802 = _0x31de0e;
    _0x297d20[_0x374802(0x146)] == _0x374802(0x13a) &&
      (_0x297d20[_0x374802(0x13c)](), playAudio());
  });
function playAudio() {
  var _0x24adca = _0x31de0e;
  try {
    player1 && (player1['destroy'](), (done1 = ![]));
  } catch (_0x845651) {}
  var _0x4d7787 = input[_0x24adca(0x142)][_0x24adca(0x132)](
    /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/
  );
  return (
    _0x4d7787 == undefined
      ? (_0x4d7787 = input[_0x24adca(0x142)])
      : _0x4d7787[_0x24adca(0x15f)] >= 0x8
      ? (_0x4d7787 = _0x4d7787[0x7])
      : (_0x4d7787 = input['value']),
    (player1 = new YT[_0x24adca(0x13b)](_0x24adca(0x133), {
      height: _0x24adca(0x14a),
      width: _0x24adca(0x15c),
      playerVars: { autoplay: 0x1, controls: 0x0, loop: 0x1 },
      videoId: _0x4d7787,
      events: { onReady: onPlayer1Ready, onStateChange: onPlayer1StateChange },
    })),
    ![]
  );
}
function onPlayer1Ready(_0x178ca9) {
  var _0x2f5e0d = _0x31de0e;
  _0x178ca9['target'][_0x2f5e0d(0x15d)](),
    player[_0x2f5e0d(0x13f)](0x0),
    localStorage[_0x2f5e0d(0x137)]('lastSong', input[_0x2f5e0d(0x142)]),
    (done1 = !![]);
}
var done1 = ![];
function onPlayer1StateChange(_0x4daf8f) {
  var _0x4c71d0 = _0x31de0e;
  if (
    _0x4daf8f[_0x4c71d0(0x157)] == YT[_0x4c71d0(0x140)][_0x4c71d0(0x143)] &&
    !done1
  )
    done1 = !![];
  else
    _0x4daf8f[_0x4c71d0(0x157)] == YT['PlayerState'][_0x4c71d0(0x15a)] &&
      done1 &&
      (player1['seekTo'](0x0), player1[_0x4c71d0(0x15d)]());
}
const vSlider = document[_0x31de0e(0x139)]('volumeSlider');
var savedVolume = localStorage[_0x31de0e(0x158)](_0x31de0e(0x159));
try {
  if (savedVolume != undefined) savedVolume = Number(savedVolume);
} catch (_0x3c4b5a) {
  savedVolume = 0x32;
}
(vSlider[_0x31de0e(0x142)] = savedVolume),
  setInterval(() => {
    var _0x1e692c = _0x31de0e;
    if (done && player && !player1) player[_0x1e692c(0x13f)](vSlider['value']);
    if (done1 && player1) player1[_0x1e692c(0x13f)](vSlider[_0x1e692c(0x142)]);
  }, 0x14),
  setInterval(() => {
    var _0x471658 = _0x31de0e;
    localStorage[_0x471658(0x137)](_0x471658(0x159), vSlider[_0x471658(0x142)]);
  }, 0x226);
function _0x539e() {
  var _0x1226fc = [
    'target',
    'length',
    'match',
    'player1',
    '7799sFUhZQ',
    'insertBefore',
    '141aHZLVv',
    'setItem',
    'linkYT',
    'getElementById',
    'Enter',
    'Player',
    'preventDefault',
    '36796EWaDok',
    '8XgNOgB',
    'setVolume',
    'PlayerState',
    '1230327IbtwyV',
    'value',
    'PLAYING',
    'seekTo',
    '10930oZfpSA',
    'key',
    'nD1OzFHZWxM',
    '255428fludMT',
    'addEventListener',
    '1280',
    'keyup',
    'https://www.youtube.com/iframe_api',
    'lastSong',
    '6ZNiTXQ',
    '2060535HwoTjd',
    '957612feBBHv',
    'onload',
    'src',
    'stopVideo',
    'getElementsByTagName',
    'script',
    '3578940NfJqoi',
    'data',
    'getItem',
    'volume',
    'ENDED',
    'player',
    '720',
    'playVideo',
  ];
  _0x539e = function () {
    return _0x1226fc;
  };
  return _0x539e();
}
