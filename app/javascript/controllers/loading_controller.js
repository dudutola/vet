import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["spinner", "text"]

  connect() {
    console.log("hii")
  }

  showSpinner() {
    this.spinnerTarget.classList.remove("hidden")
    this.textTarget.classList.remove("hidden")
  }

  hideSpinner() {
    this.spinnerTarget.classList.add("hidden")
    this.textTarget.classList.add("hidden")
  }
}
