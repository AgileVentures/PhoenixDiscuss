import {Socket} from "phoenix"
let socket = new Socket("/socket", {params: {tokens: window.userToken}})

socket.connect();

const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {})
  channel.join()
    .receive("ok", resp => { console.log("joined successful", resp)})
    .receive("error", resp => { console.log("unable to join", resp)})
    
  document.querySelector('button').addEventListener('click', () => {
    const body = document.querySelector('textarea').value;
    
    channel.push('comment:add', { body: body })
  });
  const liveDiv = document.querySelector('#comments-list')
  channel.on('live_response', payload => {
    liveDiv.innerHTML += payload.html;
  });
    
}

// window.createSocket = createSocket;

export default createSocket;