let modalOverlay;
let inService = false;

window.addEventListener("DOMContentLoaded", () => {
  modalOverlay = document.getElementById("modal-overlay");
});

window.addEventListener("message", (event) => {
  const data = event.data;

  if (data.action === "openUI") {
    modalOverlay.classList.remove("hidden");
    modalOverlay.classList.add("flex");
  }
});

function closeModal() {
  modalOverlay.classList.add("hidden");
  modalOverlay.classList.remove("flex");

  fetch(`https://${GetParentResourceName()}/closeUI`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({}),
  });
}

function acceptJob() {
  const btnAccept = document.getElementById("btn-accept");
  const btnCancel = document.getElementById("btn-cancel");

  inService = !inService;

  if (inService) {
    btnAccept.innerText = "Sair do trabalho";
    btnCancel.classList.add("hidden");
  } else {
    btnAccept.innerText = "Aceitar";
    btnCancel.classList.remove("hidden");
  }

  fetch(`https://${GetParentResourceName()}/acceptedJob`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({ accepted: inService }),
  });
  closeModal();
}

document.addEventListener("keydown", (event) => {
  if (event.key === "Escape") {
    closeModal();
  }
});
