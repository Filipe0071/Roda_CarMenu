$(function(){

    window.addEventListener("message", function(event){
        $('#carhud-main-container').draggable();
        var evento = event.data;
        if ( evento.action == 'open' ) {
            $('#damageLevel').css('width', evento.engine+ '%');
            $('#fuelLevel').css('width', evento.fuel+ '%');
            $('#car-name').html('Car: '+evento.carname);
            $('#plate-name').html('Plate: '+evento.plate)
            $('#carhud-main-container').fadeIn(1000)
        } else if (evento.action == 'close') {
            $('#carhud-main-container').fadeOut(1000)
        }
        
        if (evento.action == 'error') {
            $('.msgerror').html(evento.msg)
            $('.cards').fadeIn(1000)
            setTimeout(() => {
                $('.cards').fadeOut(2500)
            }, 2500);
        }

    })    
})



$('#offcar').on('click', function () {
 
        $.post('http://Roda_CarMenu/motor', JSON.stringify({}));
});


$('#lookcar').on('click', function () {
        $.post('http://Roda_CarMenu/vehdoorlock', JSON.stringify({}));
});

$('.seat').on('click', function () {
    var seatIndex = $(this).attr('value');
    $.post('http://Roda_CarMenu/switchSeat', JSON.stringify({
        seatIndex: seatIndex
    })
    );
});

$('.window').on('click', function () {
    var windowIndex = $(this).attr('value');
    $.post('http://Roda_CarMenu/togglewindow', JSON.stringify({
        windowIndex: windowIndex
    })
    );
});

$('.puertas').on('click', function () {
    var doorIndex = $(this).attr('value');
    $.post('http://Roda_CarMenu/openDoor', JSON.stringify({
        doorIndex: doorIndex
    })
    );
});

$(document).keyup((e) => {
    if (e.key === "Escape") {
        $("#carhud-main-container").fadeOut(1000);
        setTimeout(() => {
            $.post('https://Roda_CarMenu/exit', JSON.stringify({}));
        }, 300);
    }
});

