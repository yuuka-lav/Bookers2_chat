class ChatsController < ApplicationController
  def show
    @user = User.find(params[:id])
    @chat = Chat.new
    # pluckはモデルで使用されているテーブルからカラムを複数でも取得する
    rooms = current_user.user_rooms.pluck(:room_id) # room_idを全部引っ張る
    # 中間テーブルからuserとroomのidが一致してるモノを探す
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    # もしuserとroomのidが一致してるモノがなかったら作成
    if user_rooms.nil?
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    else
      @room = user_rooms.room
    end
    @chats = @room.chats
  end

  def create
    @room = Room.find(params[:room_id])
    @chats = @room.chats
    @chat = current_user.chats.new(chat_params)
    @chat.room_id = @room.id
    @chat.save
  end

  private
  def chat_params
    params.require(:chat).permit(:message)
  end
end
