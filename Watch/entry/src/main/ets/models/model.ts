class HeartZone {
  title: string
  description: string
  task: string
  image: string

  constructor(title?: string, description?: string, task?: string, image?: string) {
    this.title = title
    this.description = description
    this.task = task
    this.image = image
  }
}

export default HeartZone