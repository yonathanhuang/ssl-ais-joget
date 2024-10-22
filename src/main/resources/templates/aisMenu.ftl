<script src="${googleAPIURL}" async defer></script>

<div id="map"></div>
<div id="position-data"></div>

<script>
    const container = document.getElementById("position-data");
    let map;
    let pingInterval;

    // Initialize the map
    function initMap() {
        map = new google.maps.Map(document.getElementById('map'), {
            center: { lat: 0, lng: 0 }, // Initial map center
            zoom: 2 // Initial zoom level
        });
    }

    function connectWebSocket() {
        const socket = new WebSocket("wss://stream.aisstream.io/v0/stream");

        socket.onopen = function (event) {
            console.log("Socket is open", event);
            const subscriptionMessage = {
                Apikey: "b759842e35a0c6fe8515173b3a73e16bc850b115",
                BoundingBoxes: [
                    [
                        [-180, -90],
                        [180, 90],
                    ],
                ],
            };
            socket.send(JSON.stringify(subscriptionMessage));

            // Start sending ping messages every 30 seconds
            pingInterval = setInterval(() => {
                socket.send(JSON.stringify({ type: "ping" }));
            }, 30000);
        };

        socket.onmessage = function (event) {
            try {
                const aisMessage = JSON.parse(event.data);
                if (aisMessage["MessageType"] === "PositionReport") {
                    let positionReport = aisMessage["Message"]["PositionReport"];
                    const positionMessage = 'ShipId: '+positionReport["UserID"]+' Latitude: '+positionReport["Latitude"] +' Longitude: '+positionReport["Longitude"];

                    // Display position message
                    const span = document.createElement("span");
                    span.innerText = positionMessage;
                    container.appendChild(span);
                    container.appendChild(document.createElement("br")); // Add a line break

                    // Update the map with the new position
                    const lat = positionReport["Latitude"];
                    const lon = positionReport["Longitude"];
                    const position = { lat: lat, lng: lon };

                    const marker = new google.maps.Marker({
                        position: position,
                        map: map,
                        title: 'ShipId: '+positionReport["UserID"]
                    });

                    const infoWindow = new google.maps.InfoWindow({
                        content: positionMessage
                    });

                    marker.addListener("click", () => {
                        infoWindow.open(map, marker);
                    });

                    // Optionally center the map on the new position
                    map.setCenter(position);
                }
            } catch (error) {
                console.error("Error parsing message:", error);
            }
        };

        socket.onclose = function (event) {
            console.log("Socket is closed", event);
            clearInterval(pingInterval); // Clear ping interval
            if (!event.wasClean) {
                // Reconnect after a delay
                setTimeout(connectWebSocket, 5000); // Reconnect after 5 seconds
            }
        };

        socket.onerror = function (error) {
            console.error("WebSocket Error: ", error);
        };

        console.log("Created socket", socket);
    }

    // Initialize Google Map and WebSocket
    window.onload = function() {
        initMap();
        connectWebSocket();
    }
</script>