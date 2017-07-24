namespace :hardware do
  desc 'Create all the hardware items'
  task :create => :environment do

    hardware_items = [
      HardwareItem.new(
        {
          upc: 895632742,
          name: "Arduino Uno",
          count: 15,
          category: "Microcontrollers"
        }
      ),
      HardwareItem.new(
        {
          upc: 397464010,
          name: "Intel Edison",
          count: 3,
          category: "Microcontrollers"
        }
      ),
      HardwareItem.new(
        {
          upc: 572890984,
          name: "Photon Kit",
          count: 4,
          category: "Microcontrollers"
        }
      ),
      HardwareItem.new(
        {
          upc: 318369043,
          name: "Vilros Arduino Starter Kit",
          count: 25,
          category: "Microcontrollers"
        }
      ),
      HardwareItem.new(
        {
          upc: 476260842,
          name: "Element 14 BeagleBone Black",
          count: 4,
          category: "Microprocessors"
        }
      ),
      HardwareItem.new(
        {
          upc: 769568820,
          name: "Intel Galileo",
          count: 1,
          category: "Microprocessors"
        }
      ),
      HardwareItem.new(
        {
          upc: 159147627,
          name: "NVIDIA Jetson Developer Kit 1",
          count: 3,
          category: "Microprocessors"
        }
      ),
      HardwareItem.new(
        {
          upc: 596413070,
          name: "Rasberry Pi 2 - Model B",
          count: 14,
          category: "Microprocessors"
        }
      ),
      HardwareItem.new(
        {
          upc: 778653730,
          name: "Rasberry Pi 3 - Model B",
          count: 23,
          category: "Microprocessors"
        }
      ),
      HardwareItem.new(
        {
          upc: 849756036,
          name: "16x2 LCD Keypad Shield for Arduino V2",
          count: 15,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 201493882,
          name: "4WD Multi Chassis Kit",
          count: 5,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 900959335,
          name: "Adafruit NFC + RFID Shield for Arduino",
          count: 4,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 877157274,
          name: "Arduino 37 Sensor Kit",
          count: 3,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 200654501,
          name: "Arduino Motor Shield",
          count: 2,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 806127238,
          name: "Bluetooth Low Energy Pioneer Kit",
          count: 20,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 561661166,
          name: "Classic GameCube Controller USB",
          count: 5,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 454105310,
          name: "DE1-SoC Terasic FPGA Boards",
          count: 5,
          category: "Other"

        }
      ),
      HardwareItem.new(
        {
          upc: 410735781,
          name: "Edimax N150 Wi-Fi Nano USB Adapter",
          count: 10,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 699017666,
          name: "Hexbug Vex Robotics Scarab Construction Set",
          count: 1,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 384806198,
          name: "LCD Touch Shield for Arduino",
          count: 3,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 175168350,
          name: "Leap Motion VR Developer Mount",
          count: 2,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 675176334,
          name: "Mbed Application Shield",
          count: 9,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 990565173,
          name: "PiFace Digital",
          count: 8,
          category: "Other"

        }
      ),
      HardwareItem.new(
        {
          upc: 234783211,
          name: "Rasberry Pi Camera V2",
          count: 3,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 758434818,
          name: "Rasberry Pi NoIR Camera Board",
          count: 1,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 249598711,
          name: "Solderless Breadboard",
          count: 13,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 202948702,
          name: "iRobot Create 2 Programmable Robot",
          count: 1,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 562517712,
          name: "6 Axis Gyro Quadcopters",
          count: 5,
          category: "Other"
        }
      ),
      HardwareItem.new(
        {
          upc: 328810395,
          name: "Leap Motion",
          count: 13,
          category: "Sensors"
        }
      ),
      HardwareItem.new(
        {
          upc: 581267978,
          name: "Myo Gesture Control Armband",
          count: 4,
          category: "Wearables"

        }
      ),
      HardwareItem.new(
        {
          upc: 410735781,
          name: "Edimax N150 Wi-Fi Nano USB Adapter",
          count: 10,
          category: "Other"
        }
      )
    ]


    hardware_items.each do |item|
      item.save
    end


    

  end
end