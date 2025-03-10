// script.js
async function init() {
    try {
      console.log("Fetching API key...");
      const response = await fetch("http://localhost:4000/session");
      const { apiKey } = await response.json();
      console.log("API key received:", apiKey);
  
      const pc = new RTCPeerConnection();
      console.log("RTCPeerConnection created.");
  
      const audioEl = document.createElement("audio");
      audioEl.autoplay = true;
      document.body.appendChild(audioEl);
      console.log("Audio element created and appended to DOM.");
  
      pc.ontrack = (event) => {
        console.log("Remote audio track received:", event.streams[0]);
        audioEl.srcObject = event.streams[0];
      };
  
      const micStream = await navigator.mediaDevices.getUserMedia({ audio: true });
      console.log("Microphone stream obtained.");
      micStream.getTracks().forEach(track => pc.addTrack(track, micStream));
      console.log("Local audio track added to RTCPeerConnection.");
  
      const dc = pc.createDataChannel("oai-events");
      dc.onopen = () => console.log("Data channel open.");
      dc.onmessage = (event) => console.log("Data channel message:", event.data);
  
      const offer = await pc.createOffer();
      console.log("SDP Offer created:", offer);
      await pc.setLocalDescription(offer);
  
      const model = "gpt-4o-realtime-preview-2024-12-17";
      const baseUrl = "https://api.openai.com/v1/realtime";
  
      const sdpResponse = await fetch(`${baseUrl}?model=${model}`, {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${apiKey}`,
          "Content-Type": "application/sdp"
        },
        body: offer.sdp
      });
  
      if (!sdpResponse.ok) {
        const err = await sdpResponse.text();
        throw new Error(`OpenAI API error: ${err}`);
      }
  
      const answerSdp = await sdpResponse.text();
      console.log("SDP Answer received:", answerSdp);
      await pc.setRemoteDescription({ type: "answer", sdp: answerSdp });
      console.log("Remote SDP Answer set. Connection established!");
  
    } catch (error) {
      console.error("Error during WebRTC setup:", error);
    }
  }