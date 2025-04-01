#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <fcntl.h>
#include <errno.h>
#include <termios.h>
#include <unistd.h>

int main(int argc, char** argv) {

    int serial_port = open(argc > 1 ? argv[1] : "/dev/ttyS0", O_RDWR);
    struct termios tty;

    if(tcgetattr(serial_port, &tty) != 0) {
        printf("Error %i from tcgetattr: %s\n", errno, strerror(errno));
    }

    tty.c_cflag &= ~PARENB;
    tty.c_cflag &= ~CSTOPB;
    tty.c_cflag |= CS8;
    tty.c_lflag &= ~ICANON;
    tty.c_lflag &= ~ECHO;
    tty.c_iflag &= ~(IXON | IXOFF | IXANY);

    cfsetospeed(&tty, B576000);
    cfsetispeed(&tty, B576000);

    if (tcsetattr(serial_port, TCSANOW, &tty) != 0) {
        printf("Error %i from tcsetattr: %s\n", errno, strerror(errno));
    }

    printf("Playing the music from stdin on serial port\n\n");
    printf("Example usage:\n");
    printf("\tffmpeg -i ./audiofile.ogg -f s8 -acodec pcm_s8 -ar 58000 -ac 1 - | serial-sound /dev/ttyS0\n");

    char buffer[1024];
    while(read(STDIN_FILENO, buffer, sizeof(buffer))) {
        for(int i = 0; i<sizeof(buffer); i++) {
            int tmp = *(int8_t*)(buffer+i);
            tmp = (tmp+127)/32;
            buffer[i] = 0xff << (8 - tmp);
        }
        write(serial_port, buffer, sizeof(buffer));
    }
    return 0;
}
