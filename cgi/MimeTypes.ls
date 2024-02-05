
  do ->

    mime-type = (type, sub-type) -> "#type/#sub-type"

    application = -> mime-type \application, it

    audio = -> mime-type \audio, it
    image = -> mime-type \image, it
    text  = -> mime-type \text,  it

    mime-types =

      js:   application \javascript
      json: application \json
      zip:  application \zip

      svg: image 'svg+xml'

      form-data: mime-type \multipart, \form-data

      css:  text \css
      html: text \html
      xml:  text \xml

    {
      mime-type,
      application, audio, image, text,
      mime-types
    }