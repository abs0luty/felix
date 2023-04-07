use crate::print::PRINTER;

pub static mut SHELL: Shell = Shell {
    buffer: [0 as char; 256],
    cursor: 0,
};

const PROMPT: &str = "felix> ";

pub struct Shell {
    buffer: [char; 256],
    cursor: usize,
}

impl Shell {
    pub fn init(&mut self) {
        self.buffer = [0 as char; 256];
        self.cursor = 0;

        print!("{}", PROMPT);
    }

    pub fn add(&mut self, c: char) {
        self.buffer[self.cursor] = c;
        self.cursor += 1;

        print!("{}", c);
    }

    pub fn backspace(&mut self) {
        if self.cursor > 0 {
            self.buffer[self.cursor] = 0 as char;
            self.cursor -= 1;

            unsafe {
                PRINTER.delete();
            }
        }
    }

    pub fn enter(&mut self) {
        newln!();
        self.interpret();
        self.init();
    }

    fn interpret(&self) {
        match self.buffer {
            b if equals("ping", &b) => {
                println!("PONG!");
            }
            _ => {
                println!("Unknown command!");
            }
        }
    }
}

fn equals(short: &str, long: &[char]) -> bool {
    let mut i = 0;
    for c in short.chars() {
        if c != long[i as usize] {
            return false;
        }
        i += 1;
    }
    true
}

