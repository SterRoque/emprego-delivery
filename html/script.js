let modalOverlay;

window.addEventListener('DOMContentLoaded', () => {
  modalOverlay = document.getElementById('modal-overlay');
});

window.addEventListener('message', (event) => {
  const data = event.data;

  if (data.action === 'openUI') {
    modalOverlay.classList.remove('hidden');
    modalOverlay.classList.add('flex');
  } 
});


function closeModal() {

  modalOverlay.classList.add('hidden');
  modalOverlay.classList.remove('flex'); 

  fetch(`https://${GetParentResourceName()}/closeUI`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',  
    },
    body: JSON.stringify({}),
  });
}

function acceptJob() {
  fetch(`https://${GetParentResourceName()}/acceptedJob`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',  
    },
    body: JSON.stringify({ accepted: true }),
  });
  closeModal();
}

document.addEventListener('keydown', (event) => {
  if (event.key === 'Escape') {
    closeModal();
  }
}) 


