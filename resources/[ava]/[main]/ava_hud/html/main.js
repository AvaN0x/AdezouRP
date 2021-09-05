
$(function () {
    $('.mainStats').hide();
    window.addEventListener('message', function (event) {
        if (event.data.action == "setJobs") {
            $('#jobs').empty();
            if (event.data.jobs.length > 0) {
                for (const job of event.data.jobs) {
                    $('#jobs').append(`
                        <div class="stat">
                            <img src="img/jobs/${job.name}.png"><span>${job.label} - ${job.gradeLabel}</span>
                        </div>
                    `);
                }
            } else {
                $('#jobs').append(`
                    <div class="stat">
                        <span>Sans emploi</span>
                    </div>
                `);
            }

            if ($('#jobs').is(":hidden")) {
                $('#jobs').fadeIn(500).fadeOut(2000);
            }

            // } else if (event.data.action == "updateStatus") {
            //     updateStatus(event.data.status);
        } else if (event.data.action == "itemNotification") {
            let elem = $('<div>' + (event.data.add ? '+' : '-') + event.data.count + ' ' + event.data.label + '</div>');
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
    var hunger = status[0]
    var thirst = status[1]
    var drunk = status[2]
    var drugged = status[3]
    var injured = status[4]
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
function setProgressFuel(percent, element) {
    var circle = document.querySelector(element);
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $(element).parent().parent().find('span');

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent * 73) / 100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(Math.round(percent));
}

// Speed
function setProgressSpeed(value, element) {
    var circle = document.querySelector(element);
    var radius = circle.r.baseVal.value;
    var circumference = radius * 2 * Math.PI;
    var html = $(element).parent().parent().find('span');
    var percent = value * 100 / 220;
    if (percent > 100) percent = 100;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    const offset = circumference - ((-percent * 73) / 100) / 100 * circumference;
    circle.style.strokeDashoffset = -offset;

    html.text(value);
}
