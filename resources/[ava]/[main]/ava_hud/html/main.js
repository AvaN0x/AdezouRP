﻿let tankSize = 0.0;

$(function () {
    $('.mainStats').hide();
    window.addEventListener('message', function (event) {
        if (event.data.action == "setJobs") {
            $('#jobs').empty();
            $('#gangs').empty();
            let hasNonGangJob = false
            if (event.data.jobs.length > 0) {
                for (const job of event.data.jobs) {
                    if (!job.isGang)
                        hasNonGangJob = true;
                    const target = job.isGang ? "gangs" : "jobs";
                    $(`#${target}`).append(`
                        <div class="stat">
                            <img src="img/${target}/${job.name}.png"><span>${job.label} - ${job.gradeLabel}</span>
                        </div>
                    `);
                }
            }
            if (!hasNonGangJob) {
                $('#jobs').append(`
                    <div class="stat">
                        <span>Sans emploi</span>
                    </div>
                `);
            }

            if ($('.mainStats').is(":hidden")) {
                $('.mainStats').fadeIn(500).fadeOut(2000);
            }

        } else if (event.data.action == "updateStatus") {
            $(`#${event.data.name} .bg`).css('height', `${event.data.percent}%`)
            switch (event.data.name) {
                case "hunger":
                case "thirst":
                    break;
                default:
                    if (event.data.percent > 0)
                        $(`#${event.data.name}`).show();
                    else
                        $(`#${event.data.name}`).hide();
                    break;
            }
        } else if (event.data.action == "itemNotification") {
            let elem = $('<div>' + (event.data.add ? '+' : '-') + event.data.count.toLocaleString('fr-FR') + ' ' + event.data.label + '</div>');
            $('#inventoryNotifications').append(elem);

            $(elem).delay(3000).fadeOut(1000, () => {
                elem.remove();
            })
        } else if (event.data.action == "isBigmapOn") {
            $('#playerStats')[event.data.toggle ? "addClass" : "removeClass"]("bigMap");

        } else if (event.data.action == "toggle") {
            $('#ui')[event.data.show ? "show" : "hide"]();
        } else if (event.data.action == "togglePlayerStats") {
            $('#playerStats')[event.data.show ? "show" : "hide"]();
        } else if (event.data.action == "toggleMainStats") {
            $('.mainStats')[event.data.show ? "show" : "hide"]();
        } else if (event.data.action == "showcarhud") {
            if (event.data.showhud) {
                $('.huds').fadeIn();
                setProgressSpeed(event.data.speed, '.progress-speed');
                setProgressFuel(event.data.fuel, '.progress-fuel');
            } else {
                $('.huds').fadeOut();
            }
        } else if (event.data.action == "setTankSize") {
            tankSize = event.data.value;
        } else if (event.data.action == "setIsElectric") {
            $('.progress-fuel').toggleClass('electric', event.data.value);
        } else if (event.data.action == "setbelt") {
            if (!event.data.isAccepted || event.data.belt) {
                $('.belt').fadeOut();
            } else {
                $('.belt').fadeIn();
            }
        } else if (event.data.action == "copyToClipboard") {
            let copyTextarea = document.createElement('textarea');
            let currentSelection = document.getSelection();

            copyTextarea.textContent = event.data.content;
            document.body.appendChild(copyTextarea);

            currentSelection.removeAllRanges();
            copyTextarea.select();
            document.execCommand('copy');

            currentSelection.removeAllRanges();
            document.body.removeChild(copyTextarea);
            console.log("Copy to clipboard : \n" + event.data.content);
        }
    });
});


function updateStatus(status) {
    const hunger = status[0]
    const thirst = status[1]
    const drunk = status[2]
    const drugged = status[3]
    const injured = status[4]
    $('#hunger .bg').css('height', hunger.percent + '%')
    $('#water .bg').css('height', thirst.percent + '%')
    $('#drunk .bg').css('height', drunk.percent + '%');
    $('#drugged .bg').css('height', drugged.percent + '%');
    $('#injured .bg').css('height', injured.percent + '%');
    if (drunk.percent > 0) {
        $('#drunk').show();
    } else {
        $('#drunk').hide();
    }
    if (drugged.percent > 0) {
        $('#drugged').show();
    } else {
        $('#drugged').hide();
    }
    if (injured.percent > 0) {
        $('#injured').show();
    } else {
        $('#injured').hide();
    }
}


// Fuel
function setProgressFuel(value, element) {
    const percent = value / tankSize * 100;

    const circle = document.querySelector(element);
    const radius = circle.r.baseVal.value;
    const circumference = radius * 2 * Math.PI;
    const html = $(element).parent().parent().find('span');

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent * 73) / 100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(Math.round(percent));
}

// Speed
function setProgressSpeed(value, element) {
    const circle = document.querySelector(element);
    const radius = circle.r.baseVal.value;
    const circumference = radius * 2 * Math.PI;
    const html = $(element).parent().parent().find('span');
    let percent = value * 100 / 220;
    if (percent > 100) percent = 100;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent * 73) / 100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(value);
}
