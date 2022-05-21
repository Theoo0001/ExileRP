var items = [
    {
        name: "500$",
        img: "./img/5k.png",
        chance: 90,
        type: "common"
    },
    {
        name: "10000$",
        img: "./img/10k.png",
        chance: 80,
        type: "common"
    },
    {
        name: "25000$",
        img: "./img/25k.png",
        chance: 60,
        type: "common"
    },
    {
        name: "50000$",
        img: "./img/50k.png",
        chance: 30,
        type: "rare"
    },
    {
        name: "100000$",
        img: "./img/100k.png",
        chance: 20,
        type: "rare"
    },
    {
        name: "1x Chleb",
        img: "./img/chleb.png",
        chance: 5,
        type: "common"
    },
    {
        name: "50x XGamer",
        img: "./img/xgamer.png",
        chance: 10,
        type: "epic"
    },
    {
        name: "Limitowany pojazd",
        img: "./img/limitka.png",
        chance: 3,
        type: "legendary"
    }
]

var cd = false

window.addEventListener('message', function(event)
{
    var data = event.data;
    if(data.type == "LOAD_CFG") {
        if(cd) return
        cd = true
        $(".raffle-roller-container").empty()
        $(".raffle-roller-container").css("margin-left", "0px")

        $("body").css("display", "inherit")
        items = JSON.parse(data.cfg)
        generate()
    }
}, false);

var winning;
var winningNumber;
function getRandom(i) {
    var item;
    const generated = items[Math.floor(Math.random() * items.length)]
    var randed = randomInt(0, 100)
    if(randed <= generated.chance) {
        item = '<div id="CardNumber'+i+'" class="item class_'+generated.type+'_item" style="background-image:url('+generated.img+');"></div>';
        if(i == winningNumber) {
            winning = generated
        }
    } else {
        item = getRandom(i)
    }
    return item
}

function generate() {
	$('.raffle-roller-container').css({
		transition: "sdf",
		"margin-left": "0px"
	}, 10).html('');
    winningNumber = Math.floor(randomInt(300, 1000))
	for(var i = 0;i < 1001; i++) {
        const generated = getRandom(i)
		$(generated).appendTo('.raffle-roller-container');
	}
	setTimeout(function() {
		goRoll()
	}, 500);
}
generate()
function goRoll() {
	$('.raffle-roller-container').css({
		transition: "all 8s cubic-bezier(.08,.6,0,1)"
	});
    if($('#CardNumber'+(winningNumber-4)).position() == undefined) return
    if($('#CardNumber'+(winningNumber-4)).position().left == undefined) return
    const x = $('#CardNumber'+(winningNumber-4)).position().left
	setTimeout(function() {
		$('#CardNumber'+winningNumber).addClass('winning-item');
        setTimeout(function() {
            $.post('https://css-lootboxes/win', JSON.stringify(winning), function(data){});
            items = []
            $("body").css("display", "none")
            cd = false
        }, 2500)
	}, 9000);
	$('.raffle-roller-container').css('margin-left', '-'+(x)+'px');
}
function randomInt(min, max) {
  return Math.random() * (max - min) + min;
}