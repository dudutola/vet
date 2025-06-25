class ImageRequestsController < ApplicationController
  def show
    @image_request = ImageRequest.find(params[:id])
  end

  def new
    @image_request = ImageRequest.new
  end

  def create
    @image_request = ImageRequest.new(image_request_params)

    if @image_request.save
      diagnosis = analyse_image(@image_request.image.url)
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

  def analyse_image(image)
    client = OpenAI::Client.new
    messages = [
      { "type": "text", "text": "What’s in this image?"},
      { "type": "image_url",
        "image_url": {
          "url": image,
        },
      }
    ]
    response = client.chat(
      parameters: {
        model: "gpt-4.1-mini", # Required.
        messages: [{ role: "user", content: messages}], # Required.
      }
    )
    puts response.dig("choices", 0, "message", "content")
    return response
    # => "The image depicts a serene natural landscape featuring a long wooden boardwalk extending straight ahead
  end
end


# less code, plus simple, amelioration
