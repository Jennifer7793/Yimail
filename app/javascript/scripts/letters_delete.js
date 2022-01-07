import httpClient from "lib/http/client"

document.addEventListener('turbolinks:load', () => {
  const letters = document.querySelectorAll('#letterItem')
  const checkedLetters = []

  letters.forEach((letter) => {
    letter.addEventListener('change', (e) => {
      const letterId = Number(e.target.parentNode.dataset.id)
      const isChecked = e.target.checked

      if (isChecked) {
        checkedLetters.push(letterId)
      } else {
        const letterIdIndex = checkedLetters.indexOf(letterId)
        if (letterIdIndex < 0) return
        checkedLetters.splice(letterIdIndex, 1)
      }
    })
  })

  if (trashBtn) {
    trashBtn.addEventListener("click", () => {
      httpClient.post(`/api/letters/trash`,{
        letter_ids: checkedLetters
      }).then((data) => {
        window.location.href = window.location.pathname;
      })
    })
  }
})