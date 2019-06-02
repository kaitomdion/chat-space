require 'rails_helper'

describe MessagesController,type: :controller do
  let(:group) { create(:group) }
  let(:user) { create(:user) }

      describe 'GET #index' do
        context 'ログインしているか。' do
          before do
            login user
            get :index, params: { group_id: group.id }
          end
    
          it '@messageはあるか。' do
            expect(assigns(:message)).to be_a_new(Message)
          end
    
          it '@groupはあるか。' do
            expect(assigns(:group)).to eq group
          end
    
          it 'indexのビューが描写されているか。' do
            expect(response).to render_template :index
          end
        end
        
        context 'ログインしていない。' do
          before do
            get :index, params: { group_id: group.id }
          end

          it 'indexのビューにリダイレクトできているか。' do
            expect(response).to redirect_to(new_user_session_path)
          end
        end
      end
    
      describe '#create' do
        let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }
    
        context 'ログインしている。' do
          before do
            login user
          end
    
          context '保存に成功。' do
            subject {
              post :create,
              params: params
            }
    
            it 'メッセージの保存ができているか。' do
              expect{ subject }.to change(Message, :count).by(1)
            end
    
            it 'グループ画面に戻るか。' do
              subject
              expect(response).to redirect_to(group_messages_path(group))
            end
          end
    
          context '保存に失敗。' do
            let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil) } }
    
            subject {
              post :create,
              params: invalid_params
            }
    
            it 'メッセージの保存ができなかったか。' do
              expect{ subject }.not_to change(Message, :count)
            end
    
            it 'indexのビュー画面に戻れたか。' do
              subject
              expect(response).to render_template :index
            end
          end
        end
    
        context 'ログインしていない。' do
    
          it '新規登録画面にリダイレクトするか。' do
            post :create, params: params
            expect(response).to redirect_to(new_user_session_path)
          end
        end
      end
    


end