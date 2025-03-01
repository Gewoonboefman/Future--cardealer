Future = {}
Future.Vehicles = {}
Future.CurrentPage = 1
Future.PageRow = {
    1: "home",
    2: "brand",
    3: "vehicle",
}
$('.home-page-container').html(' ');
$(`.home-page`).css({"display":"block"});
Future.choosenColor = 'black'
Future.CurrentData = {'vehicleId': false, 'currentClass': false}

$(document).ready(function(e){
    window.addEventListener('message', function(event){
        var action = event.data.action;
        switch(action) {
            case "openDealer":
                // Reset containers
                $('.home-page-container').html(' ');
                $(`.home-page`).css({"display":"block"});
                if(Future.PageRow[Future.CurrentPage] !== "home"){$(`.${Future.PageRow[Future.CurrentPage]}-page`).css({"display":"none"});}

                // Default parameters
                Future.CurrentPage = 1
                Future.choosenColor = 'black'
                Future.Vehicles = event.data.vehicles

                Future.openDealer(event.data);
                break;
            case "closeDealer":
                Future.Close(true);
                break;

            // Testdrive
            case "testdriveTimer":
                if(event.data.event){
                    $('.testdrive').css({'display':'block'});
                    $('.testdrive').animate({'right':'-2vh'});
                } else {
                    $('.testdrive').animate({'right':'-15vh'});
                    setTimeout(function(){
                        $('.testdrive').css({'display':'none'});
                        $('.testdrive').find('.minutes').html('2');
                        $('.testdrive').find('.seconds').html('00');
                    }, 750)
                }
                break;
            case "testdriveTick":
                let minutes = $('.testdrive').find('.minutes').text();
                let seconds = $('.testdrive').find('.seconds').text();
                if(minutes !== 0 && seconds !== 0){
                    newSeconds = seconds - 1;
                    if(newSeconds !== -1){
                        if (newSeconds <= "9") {
                            $('.testdrive').find('.seconds').text("0" + newSeconds);
                        } else {
                            $('.testdrive').find('.seconds').text(newSeconds);
                        }
                    } else {
                        newMinutes = minutes - 1;
                        $('.testdrive').find('.minutes').text(newMinutes);
                        $('.testdrive').find('.seconds').text('59');
                    }
                } else {
                    $('.testdrive').css({'display':'none'});
                }
                break;
        }
    });
});

Future.openDealer = function(data){
    let vehicles = data.vehicles;
    $.each(vehicles, function(k, v){
        let brandLower = k.toLowerCase().replace(/ /g,"_");
        $('.home-page-container').append(`<div class="home-page-container-option" data-brand="${k}"><img src="merken/${brandLower}.png" class="home-page-container-option-logo"><div class="home-page-container-option-label">${k}</div></div>`)
    });

    $('.cardealer').css({"display":"block"})
    $('.cardealer').animate({'top':'0'})
}

// Change color
$(document).on('click', '.vehicle-page-defaultColors-color', function(event){
    let newColor = $(this).data('color')
    
    if(Future.choosenColor !== newColor){
        $(`[data-color="${Future.choosenColor}"]`).removeClass('vehicle-page-defaultColors-color-active')
        $(`[data-color="${newColor}"]`).addClass('vehicle-page-defaultColors-color-active')

        let main = $(`[data-image="main"]`).attr('src')
        let side = $(`[data-image="side"]`).attr('src')
        let back = $(`[data-image="back"]`).attr('src')
        let front = $(`[data-image="front"]`).attr('src')

        $(`[data-image="main"]`).attr('src', main.toLowerCase().replace(Future.choosenColor, newColor));
        $(`[data-image="side"]`).attr('src', side.toLowerCase().replace(Future.choosenColor, newColor));
        $(`[data-image="back"]`).attr('src', back.toLowerCase().replace(Future.choosenColor, newColor));
        $(`[data-image="front"]`).attr('src', front.toLowerCase().replace(Future.choosenColor, newColor));

        Future.choosenColor = newColor
    }
});

// Open brandpage
$(document).on('click', '.home-page-container-option', function(data){
    $('.brand-page-container').html(' ');
    let brand = $(this).data('brand')
    brandLower = brand.replace(/ /g,"%20");

    // Setup banner
    $('.brand-page-banner').css({'background': 'url("banners/'+ brandLower +'.png")', 'background-position': 'center', 'background-size': '100%'})

    // Setup vehicles
    for (let vehId = 0; vehId < Future.Vehicles[brand].length; vehId++) {
        let vehicle = Future.Vehicles[brand][vehId]
        let button = `<div class="brand-page-option-readmore" data-brand="${brand}" data-vehicle="${vehId}">Meer informatie <i class="fas fa-arrow-right"></i></div>`
        $('.brand-page-container').append(`
            <div class="brand-page-option">
                <img src="https://futureroleplay.nl/cardealer/${brandLower}_${vehicle.model}_1_black.jpg" class="brand-page-option-img">
                <div class="brand-page-option-label">${vehicle.label}</div>
                <div class="brand-page-option-price">€${vehicle.price}</div>
                
                <div class="brand-page-option-stock"></div>
                <div class="brand-page-option-message">Direct leverbaar. Prijs incl. BTW.</div>
                ${button}
            </div>
        `)    
    }



    // // Technical switch, not visual
    $(`.${Future.PageRow[Future.CurrentPage]}-page`).css({'display':"none"})
    $(`.${Future.PageRow[(Future.CurrentPage + 1)]}-page`).css({'display':"block"})
    Future.CurrentPage = Future.CurrentPage + 1; 
});

// Creating productpage
$(document).on('click', '.brand-page-option-readmore', function(data){
    let merk = $(this).data('brand');
    let vehicle = $(this).data('vehicle');

    let vehicleVal = Future.Vehicles[merk][vehicle]

    Future.CurrentData.vehicleId = vehicle
    Future.CurrentData.currentClass = merk

    // Vehicle header
    $('.vehicle-page-merk-img').attr('src', `merken/${merk.toLowerCase().replace(/ /g,"_")}.png`)
    $('.vehicle-page-title').html(vehicleVal.label)
    $('.vehicle-page-merk').html(merk)
    $('#vehicle-page-price').html(vehicleVal.price)

    // Default black images
    $(`[data-image="main"]`).attr('src', `https://futureroleplay.nl/cardealer/${merk.replace(/ /g,"%20")}_${vehicleVal.model}_1_${Future.choosenColor}.jpg`)
    $(`[data-image="side"]`).attr('src', `https://futureroleplay.nl/cardealer/${merk.replace(/ /g,"%20")}_${vehicleVal.model}_2_${Future.choosenColor}.jpg`)
    $(`[data-image="back"]`).attr('src', `https://futureroleplay.nl/cardealer/${merk.replace(/ /g,"%20")}_${vehicleVal.model}_3_${Future.choosenColor}.jpg`)
    $(`[data-image="front"]`).attr('src', `https://futureroleplay.nl/cardealer/${merk.replace(/ /g,"%20")}_${vehicleVal.model}_4_${Future.choosenColor}.jpg`)

    // Vehicle Information
    $(`[data-setting="seats"]`).html(vehicleVal.vehicleConfig.seats)
    $(`[data-setting="topspeed"]`).html(vehicleVal.vehicleConfig.maxSpeed)
    $(`[data-setting="trunkspace"]`).html(vehicleVal.vehicleConfig.trunkSpace)

    // Show new page
    $(`.${Future.PageRow[Future.CurrentPage]}-page`).css({'display':"none"})
    $(`.${Future.PageRow[(Future.CurrentPage + 1)]}-page`).css({'display':"block"})
    Future.CurrentPage = Future.CurrentPage + 1;
});

$(document).on('click', '.vehicle-page-actions-action', function(data){
    let action = $(this).data('action')
    if(action == "testrit"){
        $.post('https://frp-cardealer/testDriveVehicle', JSON.stringify({
            vehicleData: {
                class: Future.CurrentData.currentClass,
                model: (Future.CurrentData.vehicleId + 1)
            }
        }))
    } else {
        $.post('https://frp-cardealer/buyVehicle', JSON.stringify({
            colour: Future.choosenColor,
            vehicleData: {
                class: Future.CurrentData.currentClass,
                model: (Future.CurrentData.vehicleId + 1)
            }
        }))
    }
});

// Change image to big
$(document).on('click', '.vehicle-page-img-detail', function(data){
    let view = $(this).data('image');
    let detailImage = $(`[data-image="${view}"]`).attr('src')
    let bigImage = $(`[data-image="main"]`).attr('src')

    $(`[data-image="main"]`).attr('src', detailImage)
    $(`[data-image="${view}"]`).attr('src', bigImage)
});

// Close function runnen
$(document).on('click', '[data-action="close"]', function(data){
    Future.Close();
});

// Close function himself
Future.Close = function(fullClose){
    Future.choosenColor = 'black';
    if(Future.CurrentPage == 1 || fullClose){
        $('.cardealer').animate({'top':'-180vh'})
        setTimeout(function(){
            $('.cardealer').css({"display":"none"})
            $.post('https://frp-cardealer/closeDealer', JSON.stringify({}))
        }, 400)
    } else {
        $(`.${Future.PageRow[Future.CurrentPage]}-page`).css({'display':'none'})
        $(`.${Future.PageRow[Future.CurrentPage - 1]}-page`).css({'display':'block'})
        Future.CurrentPage = Future.CurrentPage - 1

        Future.CurrentData.vehicleId = false
        Future.CurrentData.currentClass = false
    }
}