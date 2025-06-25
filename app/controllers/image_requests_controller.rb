class ImageRequestsController < ApplicationController
  def show
    @image_request = ImageRequest.find(params[:id])
  end

  def new
    @image_request = ImageRequest.new
    @image_requests = ImageRequest.all
  end

  def create
    @image_request = ImageRequest.new(image_request_params)

    if @image_request.save
      diagnosis = analyze_image(@image_request.image.url)
      @image_request.update(diagnosis: diagnosis)
      redirect_to @image_request, notice: "done done"
    else
      render :new
    end
  end

  private

  def image_request_params
    params.require(:image_request).permit(:title, :diagnosis, :image)
  end

  def analyze_image(image_url)
    client = OpenAI::Client.new
    messages = [
      { "type": "text", "text": "What’s in this image?"},
      { "type": "image_url",
        "image_url": {
          "url": image_url,
        },
      }
    ]
    response = client.chat(
      parameters: {
        model: "gpt-4.1-mini", # Required.
        messages: [{ role: "user", content: messages}], # Required.
      }
    )

    return response.dig("choices", 0, "message", "content")
    # => "The image depicts a serene natural landscape featuring a long wooden boardwalk extending straight ahead
  end
end


# less code, plus simple, amelioration
# drop img
# ImageRequest.destroy_all.where()
# ImageRequest.all.each { |img| img.image.key == nil img.destroy }
# ImageRequest.all.each { |img| img.destroy if img.image.key == nil  }
