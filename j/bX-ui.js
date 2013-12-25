var UI = function (fwt) {

	var redim_clk;

	// Resizes canvas with window
	var adjust = function () {

		//> Main menu size
		if ($("section#main #frame2").innerWidth() * 0.8 < $("section#main #frame2").innerHeight())
		{
			var side = Math.min(  $("section#main #frame2").innerWidth() * 0.7  , 280);
			$("section#main #sight")
			 .css('width', side)
			 .css('height', side)
			 .css('margin-left', - side / 2 - 5)
			 .css('margin-top', - (side+10) / 2 );

			$("section#main #selector")
			 .css('height', side)
			 .css('margin-top', - (side+10) / 2 + 5);

			$("section#main #tiles .tile")
			 .css('width', $("section#main #tiles").innerHeight());

		} else {
			var side = Math.min(  $("section#main #frame2").innerHeight() * 0.9  , 280);
			$("section#main #sight")
			 .css('width', side)
			 .css('height', side)
			 .css('margin-left', - side / 2 - 5)
			 .css('margin-top', - (side+10) / 2 );

			$("section#main #selector")
			 .css('height', side)
			 .css('margin-top', - (side+10) / 2 + 5 );

			$("section#main #tiles .tile")
			 .css('width', $("section#main #tiles").innerHeight());
		}

		$("section#main #tiles")
			 .css('width', ($("section#main #tiles").innerHeight() + 20) * $("section#main #tiles .tile").length);

		$("section#main #tiles")
			 .css('margin-left', - $("section#main #tiles").innerHeight()/2 - 10)
			 .css('font-size', Math.floor(side / 14));


		if(fwt.game)
			fwt.game.pauseGame(true);

		/*$("section#game").css('width',  $('#layout').innerWidth() - 12);
		$("section#game").css('height', $('#layout').innerHeight() - 12 - 20);*/

		clearTimeout(redim_clk);
		/*redim_clk = setTimeout(function() {
			$('section#game #canvas').attr("height", $("section#game").innerHeight() - 20);
			$('section#game #canvas').attr("width", $("section#game").innerWidth() - 20);

			if(fwt.game)
				fwt.game.repaint();
		}, 150);*/

		$('header, section#game #canvas, section#game #big-paused').fadeTo(1, 0);

		redim_clk = setTimeout(function() {

			// Top bar pre.
			bar1 = 18 * $("section#game").innerHeight() / 100;
			bar1 = (bar1 > 120) ? 120 : bar1;
			bar1 += 3;
			wid1 = $("section#game").innerWidth();
			hei1 = wid1 * 24 / 16;
			if (hei1 > $("section#game").innerHeight() - bar1) {
				hei1 = $("section#game").innerHeight() - bar1;
				wid1 = hei1 * 16 / 24;
			}

			// Corner bar pre.
			bar2 = 18 * $("section#game").innerWidth() / 100;
			bar2 = (bar2 > 120) ? 120 : bar2;
			bar2 += 3;
			wid2 = $("section#game").innerWidth() - bar2;
			hei2 = wid2 * 24 / 16;
			if (hei2 > $("section#game").innerHeight()) {
				hei2 = $("section#game").innerHeight();
				wid2 = hei2 * 16 / 24;
			}

			if (hei1 > hei2) {
				$('section#game #canvas').attr("width", wid1);
				$('section#game #canvas').attr("height", hei1);

				$('section#game #canvas').css({left: $("section#game").innerWidth() / 2 - wid1/2, top: ($("section#game").innerHeight() - bar1) / 2 + bar1 - hei1/2});

				bigSize = Math.min(wid1, hei1) * 40 / 100;
				$('section#game #big-paused').css({"margin-left": 0 - bigSize/2, "margin-top": 0 - bigSize/2 + bar1/2, "width": bigSize, "height": bigSize});

				$('header#top').fadeTo(200, 1);
			} else {
				$('section#game #canvas').attr("width", wid2);
				$('section#game #canvas').attr("height", hei2);

				$('section#game #canvas').css({left: ($("section#game").innerWidth() - bar2) / 2 + bar2 - wid2/2, top: $("section#game").innerHeight() / 2 - hei2/2});

				bigSize = Math.min(wid2, hei2) * 40 / 100;
				$('section#game #big-paused').css({"margin-left": 0 - bigSize/2 + bar2/2, "margin-top": 0 - bigSize/2, "width": bigSize, "height": bigSize});

				$('header#corner').fadeTo(200, 1);
			}

			if(fwt.game) {
				fwt.game.repaint();

				$('section#game #big-paused').fadeTo(200, 1);
			}

			$('section#game #canvas').fadeTo(200, 1);

		}, 150);
	}

	window.onresize = function () {
		adjust();
	}
	adjust();


}