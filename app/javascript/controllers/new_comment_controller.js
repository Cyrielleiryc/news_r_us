import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-comment"
export default class extends Controller {
  static targets = ["add", "close", "form"]

  connect() {
  }

  add() {
    this.addTarget.classList.add("d-none");
    this.closeTarget.classList.remove("d-none");
    this.formTarget.classList.remove("d-none");
  }

  close() {
    this.addTarget.classList.remove("d-none");
    this.closeTarget.classList.add("d-none");
    this.formTarget.classList.add("d-none");
  }
}
