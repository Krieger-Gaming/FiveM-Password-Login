function submitPassword() {
    var password = document.getElementById('passwordInput').value;
    fetch(`https://${GetParentResourceName()}/submitPassword`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json;charset=UTF-8'
        },
        body: JSON.stringify({ password: password })
    }).then(resp => resp.json()).then(resp => {
        if (resp.error) {
            document.getElementById('errorMessage').innerText = resp.error;
        }
    });
}

window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.action === "show") {
        document.getElementById('passwordContainer').style.display = "block";
        if (data.error) {
            document.getElementById('errorMessage').innerText = data.error;
        }
    } else if (data.action === "hide") {
        document.getElementById('passwordContainer').style.display = "none";
    }
});

