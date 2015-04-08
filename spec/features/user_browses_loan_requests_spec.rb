require "rails_helper"

RSpec.feature "unauthenticated user browses loan requests" do
  let (:user) { User.create(email: "jorge@example.com",
                            password: "pass",
                            name: "jorge")
  }
  let (:user2) { User.create(email: "jeff@example.com",
                             password: "pass",
                             name: "jeff",
                             role: 1)
  }
  let!(:loan_request) { LoanRequest.create(title: "Farm Tools",
                                           description: "help out with the farm tools",
                                           amount: "100",
                                           requested_by_date: "2015-06-01",
                                           repayment_begin_date: "2015-12-01",
                                           contributed: "50",
                                           repayment_rate: "monthly",
                                           user_id: user2.id)
  }
  before(:each) { visit "/browse" }

  scenario "can view the loan requests" do
    expect(current_path).to eq(browse_path)
    expect(page).to have_content(loan_request.title)
  end

  scenario "can view an individual item" do
    click_link_or_button "About"
    expect(page).to have_content(loan_request.title)
  end

  scenario "can add an item to the cart" do
    click_link_or_button "Contribute $25"
    expect(page).to have_content("#{loan_request.title} Added to Basket")
    visit "/cart"
    expect(page).to have_content(loan_request.title)
  end

  scenario "does not see Transfer Funds link if cart is empty" do
    visit "/cart"
    expect(page).to_not have_link("Transfer Funds")
    expect(page).to have_content("Your basket is currently empty.")
  end

  scenario "can not submit order without logging in" do
    click_link_or_button "Contribute $25"
    visit "/cart"
    click_link_or_button "Transfer Funds"
    expect(page).to have_content("Please Log In to Finalize Contribution")
    expect(current_path).to eq(cart_path)
  end

  scenario "loan requests stay in cart after log in" do
    click_link_or_button "Contribute $25"
    login_as(user)
    expect(page).to have_content("Welcome to Keevahh, #{user.name}!")
    expect(current_path).to eq(browse_path)
    visit cart_path
    expect(page).to have_content(loan_request.title)
  end
end
