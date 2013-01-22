var controls = function () {
	
	var loadPrefs = function() {
		$('#settings .custom-size-w').val(fwt.getWidth());
		$('#settings .custom-size-h').val(fwt.getHeight());
		if (fwt.getShadeEnabled())
			$("#settings #shades .alternate.true").addClass('s');
		else
			$("#settings #shades .alternate.false").addClass('s');
		$('#settings #themes .alternate[data-value="'+fwt.getColorTheme()+'"]').addClass('s');
		$('#settings #rotation .alternate[data-value="'+fwt.getRotation()+'"]').addClass('s');
		$('#settings #set .alternate[data-value="'+fwt.getPiecesSet()+'"]').addClass('s');

		$('#settings #sizes .val').removeClass('not1 not2');
	}

	// Shades:
	$("#settings #shades .alternate.false").click(function(){
		$(this).addClass('s');
		$(this).parent().children(".true").removeClass('s');
		fwt.switchShades(false);
	});
	$("#settings #shades .alternate.true").click(function(){
		$(this).addClass('s');
		$(this).parent().children(".false").removeClass('s');
		fwt.switchShades(true);
	});

	// Themes:
	$("#settings #themes .alternate.opt").click(function(){
		$("#settings #themes .alternate").removeClass('s');
		$(this).addClass('s');
		fwt.switchTheme($(this).attr("data-value"));
		fwt.repaintNextPiece();
	});

	// Rotation:
	$("#settings #rotation .alternate.opt").click(function(){
		$("#settings #rotation .alternate").removeClass('s');
		$(this).addClass('s');
		fwt.switchRotation($(this).attr("data-value"));
	});

	// Sets:
	$("#settings #set .alternate.opt").click(function(){
		$("#settings #set .alternate").removeClass('s');
		$(this).addClass('s');
		fwt.switchSet($(this).attr("data-value"));
		ui.stopGame();
	});

	// Sizes:
	$("#settings #sizes .custom-size-w").keyup(function(){
		w = $(this).val();
		if (isNaN(w) || w < 10 || w > 100) {
			$('#settings #sizes .val').addClass('not1');
			fwt.setWidth(16);
		} else {
			$('#settings #sizes .val').removeClass('not1');
			fwt.setWidth(w);
		}
		ui.stopGame();
	});

	$("#settings #sizes .custom-size-h").keyup(function(){
		h = $(this).val();
		if (isNaN(h) || h < 10 || h > 100) {
			$('#settings #sizes .val').addClass('not2');
			fwt.setHeight(24);
		} else {
			$('#settings #sizes .val').removeClass('not2');
			fwt.setHeight(h);
		}
		ui.stopGame();
	});

	this.loadPrefs = loadPrefs;
}

var cmd = new controls();